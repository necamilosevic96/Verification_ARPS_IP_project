library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils_pkg.all;

entity control_block is
    Generic(
        W_DATA: integer:=8;
        W_ADDRESS: integer:=16;
        MB_SIZE:     integer:=16;
        P_SIZE:      integer:=7;
        ROW_SIZE:    integer:=256;  --row,i,y
        COL_SIZE:    integer:=256   --col,j,x
    );
    Port(
    --Control Block interfaces
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        start : in STD_LOGIC;
        ready : out STD_LOGIC;
        interrupt: out STD_LOGIC;
		
        --SAD_BLOCK inteface
        i_curr_sad : out  std_logic_vector(W_DATA-1 downto 0);
        j_curr_sad : out  std_logic_vector(W_DATA-1 downto 0);
        i_ref_sad : out  std_logic_vector(W_DATA-1 downto 0);
        j_ref_sad : out  std_logic_vector(W_DATA-1 downto 0);
        start_sad : out  std_logic;
        reset_sad : out  std_logic;
        ready_sad: in std_logic;
        err_sad: in std_logic_vector(2*W_DATA-1 downto 0);
        
        --BRAM_IF interface (BRAM_MV)
        addr_mv_o: out std_logic_vector(31 downto 0);
        we_mv_o: out std_logic;
        data_mv_o: out std_logic_vector(31 downto 0)
           
    );
end control_block;

architecture Behavioral of control_block is
    constant ROM_SIZE:   integer:=8; --5 location used
    constant ROM_DATA_WIDTH: integer:=2;
    constant RAM_SIZE:   integer:=8; -- 6 loacation used
    constant RAM_DATA_WIDTH: integer:=log2c((2*P_SIZE)+1); --signed from -P_SIZE to P_SIZE including 0
    constant NUM_OF_MB: integer:=(ROW_SIZE*COL_SIZE)/(MB_SIZE*MB_SIZE);--256 Motion Vector marks (not included 2 koordinates) 
   
    type state_type is (idle,s1,s2,s3,s4,s5,s6,s6e,s7,s8,s9,s10,s11,s12,s13,s14,s15,s15e,s16,s17,s18);
    
	--REGISTERS 16
    signal state_reg,state_next:state_type;
    signal i_reg,i_next:unsigned(log2c(ROW_SIZE)-1 downto 0);--8bit
    signal j_reg,j_next:unsigned(log2c(COL_SIZE)-1 downto 0);--8bit
    signal k_reg,k_next:unsigned(2 downto 0);--3bit
    signal stepSize_reg,stepSize_next:unsigned(log2c(P_SIZE)-1 downto 0);--3bit 
    signal y_reg,y_next:signed(log2c(ROW_SIZE) downto 0);--9bit
    signal x_reg,x_next:signed(log2c(COL_SIZE) downto 0);--9bit
    signal vect_y_reg,vect_y_next:signed(log2c((2*P_SIZE)+1)-1 downto 0); --4bit
    signal vect_x_reg,vect_x_next:signed(log2c((2*P_SIZE)+1)-1 downto 0); --4bit
    signal maxIndex_reg,maxIndex_next:unsigned(2 downto 0); --3bit
    signal costs_reg,costs_next:unsigned(log2c(256*MB_SIZE*MB_SIZE)-1 downto 0);--16bits
    signal cost_reg,cost_next: unsigned(log2c(256*MB_SIZE*MB_SIZE)-1 downto 0);--16bits
    signal ref_bl_iy_reg,ref_bl_iy_next: signed(log2c(ROW_SIZE) downto 0);--9bit
    signal ref_bl_jx_reg,ref_bl_jx_next: signed(log2c(COL_SIZE) downto 0);--9bit
    signal point_reg,point_next: unsigned(2 downto 0);--3bit
    signal mbCount_reg,mbCount_next: unsigned (log2c(2*(ROW_SIZE*COL_SIZE)/(MB_SIZE*MB_SIZE))-1 downto 0);--9bit
    signal i_ref_sad_reg,i_ref_sad_next: unsigned(log2c(ROW_SIZE)-1 downto 0);
    signal j_ref_sad_reg,j_ref_sad_next: unsigned (log2c(COL_SIZE)-1 downto 0);--8bit
    signal i_curr_sad_reg,i_curr_sad_next: unsigned (log2c(ROW_SIZE)-1 downto 0);--8bit
    signal j_curr_sad_reg,j_curr_sad_next:unsigned (log2c(COL_SIZE)-1 downto 0);--8bit
    

    --RAM8x4_for_iy distributed
    type ram_type_t is array (0 to RAM_SIZE-1)of signed(RAM_DATA_WIDTH-1 downto 0);
    signal ram_iy: ram_type_t:=("0000","0000","0000","0000","0000","0000","0000","0000");
    signal wr_ldsp_iy_i: std_logic;
    signal rdata_ldsp_iy_o: signed(RAM_DATA_WIDTH-1 downto 0);
    signal wdata_ldsp_iy_i: signed(RAM_DATA_WIDTH-1 downto 0);
    signal addr_ldsp_iy_i: unsigned(log2c(RAM_SIZE)-1 downto 0);
    --RAM8x4_for_jx distributed
    signal ram_jx: ram_type_t:=("0000","0000","0000","0000","0000","0000","0000","0000");
    signal wr_ldsp_jx_i: std_logic;
    signal rdata_ldsp_jx_o: signed(RAM_DATA_WIDTH-1 downto 0);
    signal wdata_ldsp_jx_i: signed(RAM_DATA_WIDTH-1 downto 0);
    signal addr_ldsp_jx_i: unsigned(log2c(RAM_SIZE)-1 downto 0);
    
    --ROM8x4_for_iy distributed
    type rom_type_t is array (0 to ROM_SIZE-1) of signed(ROM_DATA_WIDTH-1 downto 0);
    signal rom_iy: rom_type_t :=("11","00","00","00","01","00","00","00");--odd
    signal rdata_sdsp_iy_o: signed(ROM_DATA_WIDTH-1 downto 0);
    signal addr_sdsp_iy_i: unsigned(2 downto 0);
    --ROM8x4_for_jx distributed
    signal rom_jx: rom_type_t :=("00","11","00","01","00","00","00","00");--even
    signal rdata_sdsp_jx_o: signed(ROM_DATA_WIDTH-1 downto 0);
    signal addr_sdsp_jx_i: unsigned(2 downto 0);
begin
seq:
    process(clk,reset) is
    begin
    --RESET on 0
        if (reset='0') then
            state_reg<=idle;
            i_reg<=(others=>'0');
            j_reg<=(others=>'0');
            k_reg<=(others=>'0');
            stepSize_reg<=(others=>'0');
            y_reg<=(others=>'0');
            x_reg<=(others=>'0');
            vect_y_reg<=(others=>'0');
            vect_x_reg<=(others=>'0');
            maxIndex_reg<=(others=>'0');
            costs_reg<=(others=>'1'); --65535
            cost_reg<=(others=>'1');  --65535
            ref_bl_iy_reg<=(others=>'0');
            ref_bl_jx_reg<=(others=>'0');
            point_reg<=(others=>'0');
            mbCount_reg<=(others=>'0');
			
			i_ref_sad_reg<=(others=>'0');
            j_ref_sad_reg<=(others=>'0');
            i_curr_sad_reg<=(others=>'0');
            j_curr_sad_reg<=(others=>'0');

            
        elsif(clk'event and clk='1') then
            state_reg<=state_next;
            i_reg<=i_next;
            j_reg<=j_next;
            k_reg<=k_next;
            stepSize_reg<=stepSize_next;
            y_reg<=y_next;
            x_reg<=x_next;
            vect_y_reg<=vect_y_next;
            vect_x_reg<=vect_x_next;
            maxIndex_reg<=maxIndex_next;
            costs_reg<=costs_next;
            cost_reg<=cost_next;
            ref_bl_iy_reg<=ref_bl_iy_next;
            ref_bl_jx_reg<=ref_bl_jx_next;
            point_reg<=point_next;			
            mbCount_reg<=mbCount_next;
            i_ref_sad_reg<=i_ref_sad_next;
            j_ref_sad_reg<=j_ref_sad_next;
            i_curr_sad_reg<=i_curr_sad_next;
            j_curr_sad_reg<=j_curr_sad_next;		
			
        end if;

    end process;
comb:
    process(state_reg,stepSize_reg,
            i_reg,j_reg,
            x_reg,y_reg,
            vect_x_reg,vect_y_reg,
            maxIndex_reg,
            costs_reg,cost_reg,
            ref_bl_iy_reg,ref_bl_jx_reg,
            point_reg,mbCount_reg,
			i_ref_sad_reg,j_ref_sad_reg,
            i_curr_sad_reg,j_curr_sad_reg,
            start,ready_sad,
            err_sad,k_reg,
            rdata_ldsp_iy_o,rdata_ldsp_jx_o,
            rdata_sdsp_iy_o,rdata_sdsp_jx_o,
            addr_ldsp_iy_i,addr_ldsp_jx_i,
            addr_sdsp_iy_i,addr_sdsp_jx_i,
            wr_ldsp_iy_i,wr_ldsp_jx_i
    ) is
    begin
        state_next<=state_reg;
        i_next<=i_reg;
        j_next<=j_reg;
        k_next<=k_reg;
        stepSize_next<=stepSize_reg;
        x_next<=x_reg;
        y_next<=y_reg;
        vect_x_next<=vect_x_reg;
        vect_y_next<=vect_y_reg;
        maxIndex_next<=maxIndex_reg;
        costs_next<=costs_reg;
        cost_next<=cost_reg;
        ref_bl_iy_next<=ref_bl_iy_reg;
        ref_bl_jx_next<=ref_bl_jx_reg;
        point_next<=point_reg;
        mbCount_next<=mbCount_reg;
		
        i_ref_sad_next<=i_ref_sad_reg;
        j_ref_sad_next<=j_ref_sad_reg;
        i_curr_sad_next<=i_curr_sad_reg;
        j_curr_sad_next<=j_curr_sad_reg;
        --Outputs
		
        --Control_Block
        ready<='0';
        --RAM jx
        wr_ldsp_jx_i<='0';
        addr_ldsp_jx_i<=(others=>'0');
        wdata_ldsp_jx_i<=(others=>'0');
        --RAM iy
        wr_ldsp_iy_i<='0';
        addr_ldsp_iy_i<=(others=>'0');
        wdata_ldsp_iy_i<=(others=>'0');
        --ROM jx
        addr_sdsp_jx_i<=(others=>'0');
        --ROM iy
        addr_sdsp_iy_i<=(others=>'0');
        --SAD_Block

        reset_sad<='0';
        start_sad<='0';
        
        --BRAM_vectors
        addr_mv_o<=(others=>'0');
        we_mv_o<='0';
        data_mv_o<=(others=>'0');
		
        interrupt<='0';
		
        case state_reg is
            when idle=>
                ready<='1';
				
                --treba staviti READY ili interrupt
                if(start='1') then 
                    i_next<=(others=>'0');
                    cost_next<=(others=>'1');
                    costs_next<=(others=>'1');
                    vect_x_next<=to_signed(0,log2c((2*P_SIZE)+1));--4bits
                    vect_y_next<=to_signed(0,log2c((2*P_SIZE)+1));
                    mbCount_next<=(others=>'0');
                    reset_sad<='1';
                    state_next<=s1;
                else
                    state_next<=idle;
                end if;
            -------------------------------------------------------------------------------------------
            when s1=>
                j_next<=(others=>'0');
				
                state_next<=s2;
            -------------------------------------------------------------------------------------------
            when s2=>
                y_next<=to_signed(to_integer(i_reg),log2c(ROW_SIZE)+1);--9bits
                x_next<=to_signed(to_integer(j_reg),log2c(COL_SIZE)+1);--9bits
                --SAD_Block
                i_curr_sad_next<=i_reg;
                j_curr_sad_next<=j_reg;
                i_ref_sad_next<=i_reg;
                j_ref_sad_next<=j_reg;
                start_sad<='1';
				
                state_next<=s3;
			-------------------------------------------------------------------------------------------
            when s3=>
                if(ready_sad='1') then 
                    costs_next<=unsigned(err_sad);
					
                    if(j_reg=to_unsigned(0,log2c(COL_SIZE))) then
                        stepSize_next<=to_unsigned(2,3);--3bits
                        maxIndex_next<=to_unsigned(5,3);--3bits
                        vect_x_next<=(others=>'0');
                        vect_y_next<=(others=>'0');
						
                        state_next<=s5;
                    else
                        if(abs(vect_y_reg)>abs(vect_x_reg)) then
                            stepSize_next<=to_unsigned(to_integer(abs(vect_y_reg)),log2c(P_SIZE));--3bits
                        else
                            stepSize_next<=to_unsigned(to_integer(abs(vect_x_reg)),log2c(P_SIZE));--3bits
                        end if;
						
                        state_next<=s4;
                    end if;
                else
                    state_next<=s3;
                end if;
            -------------------------------------------------------------------------------------------
            when s4=>
                if(((to_unsigned(to_integer(abs(vect_y_reg)),log2c((2*P_SIZE)+1))=to_unsigned(to_integer(stepSize_reg),4)) --4bits
                and ((to_unsigned(to_integer(abs(vect_x_reg)),log2c((2*P_SIZE)+1))=to_unsigned(0,log2c((2*P_SIZE)+1)))))--4bits 
		                                              or
                ((to_unsigned(to_integer(abs(vect_x_reg)),log2c((2*P_SIZE)+1))=to_unsigned(to_integer(stepSize_reg),log2c((2*P_SIZE)+1)))--4bits 
                and  (to_unsigned(to_integer(abs(vect_y_reg)),log2c((2*P_SIZE)+1))= to_unsigned(0,log2c((2*P_SIZE)+1)))))  then --4bits
						
                    maxIndex_next<=to_unsigned(5,3);--3bit always
					
                    state_next<=s5;
                else
                    maxIndex_next<=to_unsigned(6,3);
                    --ADDR RAM VECT
					
                    addr_ldsp_jx_i<=to_unsigned(5,3);
                    wr_ldsp_jx_i<='1';
                    addr_ldsp_iy_i<=to_unsigned(5,3);
                    wr_ldsp_iy_i<='1';
                    wdata_ldsp_jx_i<=vect_x_reg;
                    wdata_ldsp_iy_i<=vect_y_reg;
					
                    state_next<=s5;
                end if;
            -------------------------------------------------------------------------------------------
			
            when s5=>
                wr_ldsp_jx_i<='1';
                addr_ldsp_jx_i<=to_unsigned(1,3);
                wdata_ldsp_jx_i<=-to_signed(to_integer(stepSize_reg),log2c((2*P_SIZE)+1));--4bits
				
                wr_ldsp_iy_i<='1';
                addr_ldsp_iy_i<=to_unsigned(0,3);
                wdata_ldsp_iy_i<=-to_signed(to_integer(stepSize_reg),log2c((2*P_SIZE)+1));--4bits			
				
                state_next<=s6;
            -------------------------------------------------------------------------------------------
            when s6=>
                wr_ldsp_jx_i<='1';
                addr_ldsp_jx_i<=to_unsigned(3,3);
                wdata_ldsp_jx_i<=to_signed(to_integer(stepSize_reg),log2c((2*P_SIZE)+1));--4bits
                
                wr_ldsp_iy_i<='1';
                addr_ldsp_iy_i<=to_unsigned(4,3);
                wdata_ldsp_iy_i<=to_signed(to_integer(stepSize_reg),log2c((2*P_SIZE)+1));--4bits
                
                cost_next<=costs_reg;
                point_next<=to_unsigned(2,3);
                k_next<=(others=>'0');
				
                state_next<=s6e;
			-------------------------------------------------------------------------------------------
            when s6e=>
                addr_ldsp_jx_i<=(others=>'0');
                addr_ldsp_iy_i<=(others=>'0');
				
                state_next<=s7;
                
            when s7=>	
                ref_bl_iy_next<=y_reg+rdata_ldsp_iy_o;
                ref_bl_jx_next<=x_reg+rdata_ldsp_jx_o;
                state_next<=s8;
            -------------------------------------------------------------------------------------------
            when s8=>
                if(ref_bl_iy_reg<to_signed(0,log2c(ROW_SIZE)+1)) or --9bit 
                ((to_integer(ref_bl_iy_reg)+MB_SIZE)>=ROW_SIZE) or 
                (ref_bl_jx_reg<to_signed(0,log2c(COL_SIZE)+1)) or --9bit 
                (to_integer(ref_bl_jx_reg)+MB_SIZE>=COL_SIZE) or
                (k_reg=to_unsigned(2,3)) or
                (stepSize_reg=to_unsigned(0,log2c(P_SIZE))) then
					
                    if(k_reg=maxIndex_reg) then
                        --ADDR RAM point
                        addr_ldsp_jx_i<=point_reg;
                        addr_ldsp_iy_i<=point_reg;
                        state_next<=s11;
                    else
                        k_next<=k_reg+1;
                        --ADDR RAM k=k+1
                        addr_ldsp_jx_i<=k_reg+1;
                        addr_ldsp_iy_i<=k_reg+1;
                        state_next<=s7;
                    end if;
                else
                    if(k_reg=maxIndex_reg) then
                        --ADDR RAM point
                        addr_ldsp_jx_i<=point_reg;
                        addr_ldsp_iy_i<=point_reg;
                        state_next<=s11;
                    else
                        k_next<=k_reg+1;
                        i_curr_sad_next<=i_reg;
                        j_curr_sad_next<=j_reg;
                        i_ref_sad_next<=to_unsigned(to_integer(ref_bl_iy_reg),log2c(ROW_SIZE));--8bits
                        j_ref_sad_next<=to_unsigned(to_integer(ref_bl_jx_reg),log2c(COL_SIZE));--8bits
                        start_sad<='1';
                        state_next<=s9;
                    end if;
                end if;
            -------------------------------------------------------------------------------------------
            when s9=>
                if(ready_sad='1') then
                    costs_next<=unsigned(err_sad);
					
                    state_next<=s10;
                else
                    state_next<=s9;
                end if;
			-------------------------------------------------------------------------------------------
            when s10=>
                if(costs_reg<cost_reg) then
                    cost_next<=costs_reg;
                    point_next<=k_reg-1;
                end if;
                addr_ldsp_jx_i<=k_reg;
                addr_ldsp_iy_i<=k_reg;
                state_next<=s7;
			-------------------------------------------------------------------------------------------
            when s11=>
                y_next<=y_reg+to_signed(to_integer(rdata_ldsp_iy_o),log2c(ROW_SIZE)+1);--9bits
                x_next<=x_reg+to_signed(to_integer(rdata_ldsp_jx_o),log2c(COL_SIZE)+1);--9bits
                costs_next<=cost_reg;
                state_next<=s12;
            -------------------------------------------------------------------------------------------
            when s12=>
                --begining od while loop
                point_next<=to_unsigned(2,3);
                k_next<=(others=>'0');
                addr_sdsp_iy_i<=(others=>'0');
                addr_sdsp_jx_i<=(others=>'0');
                state_next<=s13;
            -------------------------------------------------------------------------------------------
            when s13=>				
                ref_bl_iy_next<=y_reg+to_signed(to_integer(rdata_sdsp_iy_o),log2c(ROW_SIZE)+1);--9bits
                ref_bl_jx_next<=x_reg+to_signed(to_integer(rdata_sdsp_jx_o),log2c(COL_SIZE)+1);--9bits
                state_next<=s14;
            -------------------------------------------------------------------------------------------
            when s14=>
                if( ref_bl_iy_reg < to_signed(0,log2c(ROW_SIZE)+1) ) or --9bits 
                ( (to_integer(ref_bl_iy_reg) + MB_SIZE) >= ROW_SIZE) or 
                ( ref_bl_jx_reg < to_signed(0,log2c(COL_SIZE)+1) ) or 
                ( (to_integer(ref_bl_jx_reg) + MB_SIZE) >= COL_SIZE) or
                ( k_reg = to_unsigned(2,3) ) or
                ( ref_bl_jx_reg < (to_signed(to_integer(j_reg),log2c(COL_SIZE)+1) - to_signed(P_SIZE,log2c(COL_SIZE)+1)) ) or --9bits
                ( ref_bl_jx_reg > (to_signed(to_integer(j_reg),log2c(COL_SIZE)+1) + to_signed(P_SIZE,log2c(COL_SIZE)+1)) ) or --9bits
                ( ref_bl_iy_reg < (to_signed(to_integer(i_reg),log2c(ROW_SIZE)+1) - to_signed(P_SIZE,log2c(ROW_SIZE)+1)) ) or --9bits
                ( ref_bl_iy_reg > (to_signed(to_integer(i_reg),log2c(ROW_SIZE)+1) + to_signed(P_SIZE,log2c(ROW_SIZE)+1)) ) then --9bits
				
                    if(k_reg=5) then
                        addr_sdsp_iy_i<=point_reg;
                        addr_sdsp_jx_i<=point_reg;
                        state_next<=s16;
                    else
                        k_next<=k_reg+1;
                        addr_sdsp_iy_i<=k_reg+1;
                        addr_sdsp_jx_i<=k_reg+1;
                        state_next<=s13;
                    end if;
                else
                    if(k_reg=5) then
                        addr_sdsp_iy_i<=point_reg;
                        addr_sdsp_jx_i<=point_reg;
                        state_next<=s16;
                    else
                        k_next<=k_reg+1;--dodato
                        i_curr_sad_next<=i_reg;
                        j_curr_sad_next<=j_reg;
                        i_ref_sad_next<=to_unsigned(to_integer(ref_bl_iy_reg),log2c(ROW_SIZE));
                        j_ref_sad_next<=to_unsigned(to_integer(ref_bl_jx_reg),log2c(COL_SIZE));
                        start_sad<='1';
                        state_next<=s15;
                    end if;
                end if;
            -------------------------------------------------------------------------------------------
            when s15=>
                if(ready_sad='1') then 
                    costs_next<=unsigned(err_sad);
                    
                    state_next<=s15e;
                else
                    state_next<=s15;
                end if;
            -------------------------------------------------------------------------------------------
            when s15e=>
                if(costs_reg<cost_reg) then
                    cost_next<=costs_reg;
                    point_next<=k_reg-1;
                end if;
                addr_sdsp_iy_i<=k_reg;
                addr_sdsp_jx_i<=k_reg;
                state_next<=s13;
            -------------------------------------------------------------------------------------------
            when s16=>
                if(point_reg/=to_unsigned(2,3)) then
                    y_next<=y_reg+to_signed(to_integer(rdata_sdsp_iy_o),log2c(ROW_SIZE)+1);--9bits
                    x_next<=x_reg+to_signed(to_integer(rdata_sdsp_jx_o),log2c(COL_SIZE)+1);--9bits
                    costs_next<=cost_reg;
                    state_next<=s12; --on start of while loop
                else
                    --end of while loop
                    addr_mv_o<=std_logic_vector(to_unsigned(to_integer(shift_left(to_unsigned(to_integer(mbCount_reg),32),2)),32));--32bits
                    we_mv_o<='1';
                    data_mv_o<=std_logic_vector(to_signed(to_integer(x_reg - to_signed(to_integer(j_reg),log2c(COL_SIZE)+1)),32));--4bits
					
                    state_next<=s17;
                end if;
            -------------------------------------------------------------------------------------------
            when s17=>
                vect_x_next<=to_signed(to_integer(x_reg - to_signed(to_integer(j_reg),log2c(COL_SIZE)+1)),log2c((2*P_SIZE)+1));
                addr_mv_o<=std_logic_vector(to_unsigned(to_integer(shift_left(to_unsigned(to_integer(mbCount_reg+1),32),2)),32));--9bits
                we_mv_o<='1';
                data_mv_o<=std_logic_vector(to_signed(to_integer(y_reg - to_signed(to_integer(i_reg),log2c(ROW_SIZE)+1)),32));
                
                state_next<=s18;
            -------------------------------------------------------------------------------------------
            when s18=>
                vect_y_next<=to_signed(to_integer(y_reg - to_signed(to_integer(i_reg),log2c(ROW_SIZE)+1)),log2c((2*P_SIZE)+1));
				
                mbCount_next<=mbCount_reg+2;
                costs_next<=(others=>'1');
                if(to_integer(j_reg)=(COL_SIZE-MB_SIZE)) then
                    if(to_integer(i_reg)=(ROW_SIZE-MB_SIZE)) then
                        interrupt<='1';
                        state_next<=idle;
                    else
                        i_next<=i_reg+MB_SIZE;
                        state_next<=s1;
                    end if;
                else
                    j_next<=j_reg+MB_SIZE;
                    state_next<=s2;
                end if;
            -------------------------------------------------------------------------------------------				
            end case;
		
    end process;
    
    i_ref_sad<=std_logic_vector(i_ref_sad_reg);
    j_ref_sad<=std_logic_vector(j_ref_sad_reg);
    i_curr_sad<=std_logic_vector(i_curr_sad_reg);
    j_curr_sad<=std_logic_vector(j_curr_sad_reg);
    
RAM8x4_LDSP_jx:
    process(clk) is
    begin
    if(clk'event and clk= '1') then
        if (wr_ldsp_jx_i = '1')then 
            ram_jx(to_integer(addr_ldsp_jx_i)) <= wdata_ldsp_jx_i;
        else
            rdata_ldsp_jx_o <= ram_jx(to_integer(addr_ldsp_jx_i));
        end if;
    end if;
    end process;
    
RAM8x4_LDSP_iy:
    process(clk) is
    begin
    if(clk'event and clk= '1') then
        if (wr_ldsp_iy_i = '1')then 
            ram_iy(to_integer(addr_ldsp_iy_i)) <= wdata_ldsp_iy_i;
        else
            rdata_ldsp_iy_o <= ram_iy(to_integer(addr_ldsp_iy_i));
        end if;
    end if;
    end process;
    
ROM8x2_SDSP_jx:
    process(clk) is
    begin
        if(clk'event and clk = '1') then
            rdata_sdsp_jx_o<=rom_jx(to_integer(addr_sdsp_jx_i));
        end if;    
    end process;
ROM8x2_SDSP_iy:
    process(clk) is
    begin
        if(clk'event and clk = '1') then
            rdata_sdsp_iy_o<=rom_iy(to_integer(addr_sdsp_iy_i));
        end if;    
    end process;    
    
end Behavioral;