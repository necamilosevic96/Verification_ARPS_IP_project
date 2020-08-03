library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.utils_pkg.all;

entity bram_if is
    Generic(
           W_DATA:natural:=8;
           W_ADDRESS:natural:=16; --65536
           MB_SIZE:     integer:=16;
           P_SIZE:      integer:=7;
           ROW_SIZE:    integer:=256;  --row,i,y
           COL_SIZE:    integer:=256   --col,j,x
        );
    Port ( 
           --Interface SAD_BLOCK ref and curr 
           addr_ref_i: in std_logic_vector(W_ADDRESS-1 downto 0);
           data_ref_o: out std_logic_vector(31 downto 0);
           en_ref_i: in std_logic;
           
           addr_curr_i: in std_logic_vector(W_ADDRESS-1 downto 0);
           data_curr_o: out std_logic_vector(31 downto 0);
           en_curr_i: in std_logic;
           -----------------------------------------------------------------
           --Interface BRAM curr
           data_curr_i: in std_logic_vector(31 downto 0);
           addr_curr_o: out std_logic_vector(31 downto 0);
           we_curr_o: out std_logic_vector(3 downto 0);
           en_curr_o: out std_logic;
           rst_curr_o: out std_logic;
           --Interface BRAM ref
           data_ref_i: in std_logic_vector(31 downto 0);
           addr_ref_o: out std_logic_vector(31 downto 0);
           we_ref_o: out std_logic_vector(3 downto 0);
           en_ref_o: out std_logic;
           rst_ref_o: out std_logic;
           --Interface BRAM mv
           data_mv_o: out std_logic_vector(31 downto 0);
           addr_mv_o: out std_logic_vector(31 downto 0);
           we_mv_o: out std_logic_vector(3 downto 0);
           en_mv_o: out std_logic;
           rst_mv_o: out std_logic;
           ------------------------------------------------------------------
           --Interface Control_block
           addr_mv_i: in std_logic_vector(31 downto 0);
           we_mv_i: in std_logic;
           data_mv_i: in std_logic_vector(31 downto 0)--4
         );
end bram_if;

architecture Behavioral of bram_if is
    signal zeros :std_logic_vector(W_ADDRESS-1 downto 0):=(others=>'0');

begin
    data_ref_o<=data_ref_i;
    data_curr_o<=data_curr_i;
	addr_curr_o<=zeros & std_logic_vector(addr_curr_i);
	addr_ref_o<=zeros & std_logic_vector(addr_ref_i);
    ----------------------------------
    --BRAM curr
    we_curr_o<=(others=>'0');
    en_curr_o<=en_curr_i;
    rst_curr_o<='0';
    --BRAM ref
    we_ref_o<=(others=>'0');
    en_ref_o<=en_ref_i;
    rst_ref_o<='0';
    
    --BRAM mv
    data_mv_o<=data_mv_i;--32
    addr_mv_o<=addr_mv_i;--32
    we_mv_o<="1111" when we_mv_i='1' else
             "0000";
    en_mv_o<='1';
    rst_mv_o<='0';
   
    
end Behavioral;
