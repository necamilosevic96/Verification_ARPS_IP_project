--SAD(Sum of Absolut Difference) block
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils_pkg.all;

entity sad_block is
    generic(
        W_DATA : natural:=8;
        W_ADDRESS:natural:=16;
        ROW_SIZE: natural:=256;
        COL_SIZE: natural:=256;
        MB_SIZE: natural:=16 --from 0 to 15
    );
    port(
        i_curr_in : in  std_logic_vector(W_DATA-1 downto 0); 
        j_curr_in : in std_logic_vector(W_DATA-1 downto 0);
        i_ref_in : in  std_logic_vector(W_DATA-1 downto 0);
        j_ref_in : in  std_logic_vector(W_DATA-1 downto 0);
    ----------------BRAM_referent-------------------------------
        bref_data_in: in std_logic_vector(31 downto 0);
        bref_address_out:out std_logic_vector(W_ADDRESS-1 downto 0);
    ---------------BRAM_current--------------------------------
        bcurr_data_in: in std_logic_vector(31 downto 0);
        bcurr_address_out:out std_logic_vector(W_ADDRESS-1 downto 0);
    ------------------------------------------------------------
        start   : in  std_logic;
        clk     : in  std_logic;
        reset   : in  std_logic;
        ready   : out std_logic;
        err_out : out std_logic_vector(2*W_DATA-1 downto 0)
    );
end sad_block;

architecture Behavioral of sad_block is
    type state_type is (idle,s1,s2);
    signal state_reg,state_next:state_type;	
    signal i_reg,i_next: unsigned(log2c(MB_SIZE)-1 downto 0); 
    signal j_reg,j_next: unsigned(log2c(MB_SIZE)-1 downto 0);
    signal err_reg,err_next: unsigned(log2c(256*(MB_SIZE*MB_SIZE))-1 downto 0);
    signal tmp_curr_reg,tmp_curr_next: std_logic_vector(W_ADDRESS-1 downto 0);
    signal tmp_ref_reg,tmp_ref_next: std_logic_vector(W_ADDRESS-1 downto 0);
    signal addr_curr_reg,addr_curr_next: std_logic_vector(W_ADDRESS-1 downto 0);
    signal addr_ref_reg,addr_ref_next: std_logic_vector(W_ADDRESS-1 downto 0);
    signal sel_ref_reg,sel_ref_next: unsigned(1 downto 0);
    signal sel_curr_reg,sel_curr_next: unsigned(1 downto 0);
    signal bcurr_data: std_logic_vector(W_DATA-1 downto 0):=(others=>'0');
    signal bref_data: std_logic_vector(W_DATA-1 downto 0):=(others=>'0');
	
    constant BLOCK_SIZE:integer:=(MB_SIZE-1); --15
    constant MAX_ERR_VAL: integer:=256*(MB_SIZE*MB_SIZE);--65536
begin
--seq
    process(clk,reset) is
    begin
    if(reset='1') then
        state_reg<=idle;		
        i_reg<=(others=>'0');
        j_reg<=(others=>'0');
        err_reg<=(others=>'0');
        tmp_ref_reg<=(others=>'0');
        tmp_curr_reg<=(others=>'0');
        addr_ref_reg<=(others=>'0');
        addr_curr_reg<=(others=>'0');
        sel_curr_reg<=(others=>'0');
        sel_ref_reg<=(others=>'0');
        
    elsif(clk'event and clk='1') then
        state_reg<=state_next;
        i_reg<=i_next;
        j_reg<=j_next;
        err_reg<=err_next;
        tmp_ref_reg<=tmp_ref_next;
        tmp_curr_reg<=tmp_curr_next;
        addr_ref_reg<=addr_ref_next;
        addr_curr_reg<=addr_curr_next;
        sel_curr_reg<=sel_curr_next;
        sel_ref_reg<=sel_ref_next;

    end if;
    end process;

--comb
    process(state_reg,
            i_reg,
            j_reg,
            i_next,
            j_next,
            err_reg,
            tmp_ref_reg,
            tmp_curr_reg,
            addr_ref_reg,
            addr_curr_reg,
            sel_curr_reg,
            sel_ref_reg,
            addr_curr_next,
            addr_ref_next,
            tmp_curr_next,
            tmp_ref_next,
            start, 
            bcurr_data, 
            bref_data, 
            i_curr_in, 
            i_ref_in, 
            j_curr_in, 
            j_ref_in) is
    begin
        ready<= '0';
        bcurr_address_out<=(others=>'0');
        bref_address_out<=(others=>'0');
        err_out<=(others=>'0');
        
        state_next<=state_reg;
        i_next<= i_reg;
        j_next<= j_reg;
        err_next<= err_reg;
        tmp_ref_next<= tmp_ref_reg;
        tmp_curr_next<= tmp_curr_reg;
        addr_ref_next<= addr_ref_reg;
        addr_curr_next<= addr_curr_reg;
        sel_curr_next<= sel_curr_reg;
        sel_ref_next<= sel_ref_reg;
		
    case state_reg is
        when idle =>
            ready <= '1';
            err_out<=std_logic_vector(err_reg);
            if(start='1') then
                i_next   <= (others=>'0');
                j_next   <= (others=>'0');
                err_next   <= (others=>'0');
                tmp_ref_next   <= (others=>'0');
                tmp_curr_next   <= (others=>'0');
                addr_ref_next   <= (others=>'0');
                addr_curr_next   <= (others=>'0');
                sel_curr_next   <= (others=>'0');
                sel_ref_next   <= (others=>'0');
                state_next<=s1;
            else
                state_next<=idle;
            end if;
        when s1=>
            j_next<=(others=>'0');
            --256*(i_reg+i_curr_in)+(j_reg+j_curr_in)
            addr_curr_next <=std_logic_vector((shift_left(to_unsigned(to_integer(i_reg+unsigned(i_curr_in)),W_ADDRESS),log2c(ROW_SIZE)))+(j_next+unsigned(j_curr_in)));
            addr_ref_next <=std_logic_vector((shift_left(to_unsigned(to_integer(i_reg+unsigned(i_ref_in)),W_ADDRESS),log2c(ROW_SIZE)))+(j_next+unsigned(j_ref_in)));
            
            --addr_curr_next<=std_logic_vector(to_unsigned(to_integer((ROW_SIZE*(i_reg+unsigned(i_curr_in)))+(j_reg+unsigned(j_curr_in))),W_ADDRESS));
            --addr_ref_next<=std_logic_vector(to_unsigned(to_integer(((ROW_SIZE*(i_reg+unsigned(i_ref_in)))+(j_reg+unsigned(j_ref_in)))),W_ADDRESS));
            
            --(((addr_curr_next)>>2)<<2)
            tmp_curr_next <= std_logic_vector(shift_left(shift_right(unsigned(addr_curr_next),2),2));
            tmp_ref_next  <= std_logic_vector(shift_left(shift_right(unsigned(addr_ref_next) ,2),2));
            
            --sel_curr<=(addr_curr_next-tmp_curr_next)
            sel_curr_next<=to_unsigned(to_integer((unsigned(addr_curr_next) - unsigned(tmp_curr_next))),2);
            sel_ref_next<= to_unsigned(to_integer((unsigned(addr_ref_next)  - unsigned(tmp_ref_next))) ,2);
            --tmp_ref
            bcurr_address_out<=tmp_curr_next;
            bref_address_out<=tmp_ref_next;
            
            state_next<=s2;
        when s2=> 
             err_next<=err_reg+to_unsigned(to_integer(abs(to_signed(to_integer(unsigned(bcurr_data)),W_DATA+1)- to_signed(to_integer(unsigned(bref_data)),W_DATA+1))),log2c(MAX_ERR_VAL));
			--err=err+abs(curr_pix-ref_pix);
            if(j_reg=BLOCK_SIZE) then
                if(i_reg=BLOCK_SIZE) then
                    state_next<=idle;
                else
                    i_next<=i_reg+1;
                                       
	            state_next<=s1;
	        
		end if;
            else
                j_next<=j_reg+1;
                addr_curr_next <=std_logic_vector((shift_left(to_unsigned(to_integer(i_next+unsigned(i_curr_in)),W_ADDRESS),log2c(ROW_SIZE)))+(j_next+unsigned(j_curr_in)));
                addr_ref_next <=std_logic_vector((shift_left(to_unsigned(to_integer(i_next+unsigned(i_ref_in)),W_ADDRESS),log2c(ROW_SIZE)))+(j_next+unsigned(j_ref_in)));

                --(((addr_curr_next)>>2)<<2)
                tmp_curr_next <= std_logic_vector(shift_left(shift_right(unsigned(addr_curr_next),2),2));
                tmp_ref_next  <= std_logic_vector(shift_left(shift_right(unsigned(addr_ref_next) ,2),2));
            
                --sel_curr<=(addr_curr_next-tmp_curr_next)
                sel_curr_next<=to_unsigned(to_integer((unsigned(addr_curr_next) - unsigned(tmp_curr_next))),2);
                sel_ref_next<= to_unsigned(to_integer((unsigned(addr_ref_next)  - unsigned(tmp_ref_next))) ,2);
                --tmp_ref
                bcurr_address_out<=tmp_curr_next;
                bref_address_out<=tmp_ref_next;
                
                state_next<=s2;
            end if;
            
            
        end case;
    end process;
    	    
    
    ref:
    process(bref_data_in,sel_ref_reg) is
    begin
        case sel_ref_reg is
            when "00"=>
                bref_data<=bref_data_in(31 downto 24);
            when "01"=>
                bref_data<=bref_data_in(23 downto 16);
            when "10"=>
                bref_data<=bref_data_in(15 downto 8);
            when others =>
                bref_data<=bref_data_in(7 downto 0);
        end case;
    end process;
    
    --Select 8 bit data from 32 bit, needed for calculating
    curr:
    
    process(bcurr_data_in,sel_curr_reg) is
    begin
        case sel_curr_reg is
            when "00"=>
                bcurr_data<=bcurr_data_in(31 downto 24);
            when "01"=>
                bcurr_data<=bcurr_data_in(23 downto 16);
            when "10"=>
                bcurr_data<=bcurr_data_in(15 downto 8);
            when others =>
                bcurr_data<=bcurr_data_in(7 downto 0);
        end case;
    end process;
    
end architecture;
