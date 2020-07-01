--Stankovic Stefan EE17/2015
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils_pkg.all;

entity arps_ip is
    generic(
        W_DATA:         integer:=8;--gray
        --W_ADDRESS :     integer:=16;--row*col/mbSize*mbSize
        ROW_SIZE:       integer:=256;
        COL_SIZE:       integer:=256;
        MB_SIZE:         integer:=16;
        P_SIZE:          integer:=7
        );
    port(
        clk_i:    in std_logic;
        reset_i:  in std_logic;
        interrupt: out std_logic;
        
        start_i:  in std_logic;
        ready_o:  out std_logic;
        
        --BRAM interface MV
        addrb_mv_o: out std_logic_vector(31 downto 0);
	    dinb_mv_o: out std_logic_vector(31 downto 0);
	    enb_mv_o: out std_logic;
	    web_mv_o: out std_logic_vector(3 downto 0);
	    rstb_mv_o: out std_logic;
	    --doutb_vect_i:in std_logic_vector(31 downto 0); --not used
        --BRAM interface Ref Img
        addrb_ref_o: out std_logic_vector(31 downto 0);
	    doutb_ref_i: in std_logic_vector(31 downto 0);
	    enb_ref_o: out std_logic;
	    web_ref_o: out std_logic_vector(3 downto 0);
	    rstb_ref_o: out std_logic;
	    --din_ref_o: out std_logic_vector(31 downto 0);
	    --BRAM interface Curr Img
	    addrb_curr_o: out std_logic_vector(31 downto 0);
	    doutb_curr_i: in std_logic_vector(31 downto 0);
	    enb_curr_o: out std_logic;
	    web_curr_o: out std_logic_vector(3 downto 0);
	    rstb_curr_o: out std_logic
	    --din_curr_o: out std_logic_vector(31 downto 0)
        );
end arps_ip;

architecture Behavioral of arps_ip is
    constant W_DATA_VECT: integer:=log2c((2*P_SIZE)+1);
    constant W_ADDR_VECT: integer:=log2c(2*(ROW_SIZE*COL_SIZE)/(MB_SIZE*MB_SIZE));
    constant W_ADDRESS: integer:=log2c(ROW_SIZE*COL_SIZE);
    
    --SAD and BRAM_IF
    signal addr_ref_s:  std_logic_vector(W_ADDRESS-1 downto 0);
    signal data_ref_s:  std_logic_vector(W_DATA-1 downto 0); 
    signal addr_curr_s: std_logic_vector(W_ADDRESS-1 downto 0);
    signal data_curr_s: std_logic_vector(W_DATA-1 downto 0);
   
    --SAD and Contorl Block signals
    signal i_curr_s: std_logic_vector(W_DATA-1 downto 0);
    signal j_curr_s: std_logic_vector(W_DATA-1 downto 0);
    signal i_ref_s: std_logic_vector(W_DATA-1 downto 0);
    signal j_ref_s: std_logic_vector(W_DATA-1 downto 0);
    signal start_sad_s: std_logic;
    signal reset_sad_s: std_logic;
    signal ready_sad_s: std_logic;
    signal err_sad_s: std_logic_vector(log2c(256*MB_SIZE*MB_SIZE)-1 downto 0);--16bit 256 grayscale
    --Control Block and BRAM_IF
    signal addr_mv_s: std_logic_vector(log2c(2*(ROW_SIZE*COL_SIZE)/(MB_SIZE*MB_SIZE))-1 downto 0);
    signal we_mv_s:  std_logic;
    signal data_mv_s: signed(log2c((2*P_SIZE)+1)-1 downto 0);


begin
 
sad_block_ins:
    entity work.sad_block(Behavioral)
    generic map(W_DATA=>W_DATA,
				W_ADDRESS=>W_ADDRESS,
				ROW_SIZE=>ROW_SIZE,
				COL_SIZE=>COL_SIZE,
				MB_SIZE=>MB_SIZE)
    port map(
        clk=>clk_i,--ok
        start=>start_sad_s, --ok
        reset=>reset_sad_s, --ok
        i_curr_in=>i_curr_s, --ok
        i_ref_in=>i_ref_s, --ok
        j_curr_in=>j_curr_s, --ok
        j_ref_in=>j_ref_s, --ok
	    bref_data_in=>data_ref_s, --ok
	    bref_address_out=>addr_ref_s, --ok
	    bcurr_data_in=>data_curr_s, --ok
	    bcurr_address_out=>addr_curr_s, --ok
        err_out=>err_sad_s, --ok
        ready=>ready_sad_s --ok
    );
control_block_ins:
    entity work.control_block(Behavioral)
    generic map(W_ADDRESS=>W_ADDRESS, 
				W_DATA=>W_DATA, 
				MB_SIZE=>MB_SIZE, 
				P_SIZE=>P_SIZE, 
				ROW_SIZE=>ROW_SIZE, 
				COL_SIZE=>COL_SIZE)
    port map(
        clk=>clk_i, --ok
        reset=>reset_i, --ok
        interrupt=>interrupt, --ok
        i_curr_sad=>i_curr_s, --ok
        j_curr_sad=>j_curr_s,--ok
        i_ref_sad=>i_ref_s,--ok
        j_ref_sad=>j_ref_s,--ok
        start_sad=>start_sad_s,--ok
        reset_sad=>reset_sad_s,--ok
        ready_sad=>ready_sad_s,--ok
        err_sad=>err_sad_s,--ok
        addr_mv_o=>addr_mv_s,
        we_mv_o=>we_mv_s,
        data_mv_o=>data_mv_s,
        start=>start_i,--ok
        ready=>ready_o--ok
    );
bram_if_ins:
    entity work.bram_if(Behavioral)
    generic map(W_ADDRESS=>W_ADDRESS, 
				W_DATA=>W_DATA, 
				MB_SIZE=>MB_SIZE, 
				P_SIZE=>P_SIZE, 
				ROW_SIZE=>ROW_SIZE, 
				COL_SIZE=>COL_SIZE)
	port map(
	       --SAD interface
	       addr_ref_i=>addr_ref_s,
           data_ref_o=>data_ref_s,
           addr_curr_i=>addr_curr_s,
           data_curr_o=>data_curr_s,
           -----------------------------------------------------------------
           --Interface BRAM curr
           data_curr_i=>doutb_curr_i,
           addr_curr_o=>addrb_curr_o,
           we_curr_o=>web_curr_o,
           en_curr_o=>enb_curr_o,
           rst_curr_o=>rstb_curr_o,
           --Interface BRAM ref
           data_ref_i=>doutb_ref_i,
           addr_ref_o=>addrb_ref_o,
           we_ref_o=>web_ref_o,
           en_ref_o=>enb_ref_o,
           rst_ref_o=>rstb_ref_o,
           --Interface BRAM mv
           data_mv_o=>dinb_mv_o,
           addr_mv_o=>addrb_mv_o,
           we_mv_o=>web_mv_o,
           en_mv_o=>enb_mv_o,
           rst_mv_o=>rstb_mv_o,
           ------------------------------------------------------------------
           --Interface Control_block
           addr_mv_i=>addr_mv_s,
           we_mv_i=>we_mv_s,
           data_mv_i=>data_mv_s
	);
                
end architecture Behavioral;
--Stankovic Stefan EE17/2015