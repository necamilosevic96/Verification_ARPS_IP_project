library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.utils_pkg.all;

entity bram_if is
    Generic(
           W_DATA:natural:=8;
           W_ADDRESS:natural:=16; --16384
           MB_SIZE:     integer:=16;
           P_SIZE:      integer:=7;
           ROW_SIZE:    integer:=256;  --row,i,y
           COL_SIZE:    integer:=256   --col,j,x
        );
    Port ( 
           --Interface SAD_BLOCK ref and curr 
           addr_ref_i: in std_logic_vector(W_ADDRESS-1 downto 0);
           data_ref_o: out std_logic_vector(W_DATA-1 downto 0);
           
           addr_curr_i: in std_logic_vector(W_ADDRESS-1 downto 0);
           data_curr_o: out std_logic_vector(W_DATA-1 downto 0);
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
           addr_mv_i: in std_logic_vector(log2c(2*(ROW_SIZE*COL_SIZE)/(MB_SIZE*MB_SIZE))-1 downto 0);
           we_mv_i: in std_logic;
           data_mv_i: in signed(log2c((2*P_SIZE)+1)-1 downto 0)
         );
end bram_if;

architecture Behavioral of bram_if is
    signal zeros :std_logic_vector(W_ADDRESS-1 downto 0):=(others=>'0');
    signal sel_ref: std_logic_vector(1 downto 0);
    signal sel_curr: std_logic_vector(1 downto 0);
    signal tmp_ref: unsigned(W_ADDRESS-1 downto 0);
    signal tmp_curr: unsigned(W_ADDRESS-1 downto 0);
begin
    ref:
    process(data_ref_i,sel_ref) is
    begin
        case sel_ref is
            when "00"=>
                data_ref_o<=data_ref_i(31 downto 24);
            when "01"=>
                data_ref_o<=data_ref_i(23 downto 16);
            when "10"=>
                data_ref_o<=data_ref_i(15 downto 8);
            when others =>
                data_ref_o<=data_ref_i(7 downto 0);
        end case;
    end process;
    
    curr:
    process(data_curr_i,sel_curr) is
    begin
        case sel_curr is
            when "00"=>
                data_curr_o<=data_curr_i(31 downto 24);
            when "01"=>
                data_curr_o<=data_curr_i(23 downto 16);
            when "10"=>
                data_curr_o<=data_curr_i(15 downto 8);
            when others =>
                data_curr_o<=data_curr_i(7 downto 0);
        end case;
    end process;
    --DATA and ADDRESS conversation
    --current
    tmp_curr<=to_unsigned(to_integer(shift_left(to_unsigned(to_integer(shift_right(unsigned(addr_curr_i),2)),W_ADDRESS),2)),W_ADDRESS);
    addr_curr_o<=zeros & std_logic_vector(tmp_curr);
    sel_curr<=std_logic_vector(to_unsigned(to_integer(unsigned(addr_curr_i)- tmp_curr),2));
    --reference
    tmp_ref<=to_unsigned(to_integer(shift_left(to_unsigned(to_integer(shift_right(unsigned(addr_ref_i),2)),W_ADDRESS),2)),W_ADDRESS);    
    addr_ref_o<=zeros & std_logic_vector(tmp_ref);
    sel_ref<=std_logic_vector(to_unsigned(to_integer(unsigned(addr_ref_i)- tmp_ref),2));
    ----------------------------------
    --BRAM curr
    we_curr_o<=(others=>'0');
    en_curr_o<='1';
    rst_curr_o<='0';
    --BRAM ref
    we_ref_o<=(others=>'0');
    en_ref_o<='1';
    rst_ref_o<='0';
    
    --BRAM mv
    data_mv_o<=std_logic_vector(to_signed(to_integer(data_mv_i),32));--32
    addr_mv_o<=std_logic_vector(shift_left(to_unsigned(to_integer(unsigned(addr_mv_i)),32),2));--32
    we_mv_o<="1111" when we_mv_i='1' else
             "0000";
    en_mv_o<='1';
    rst_mv_o<='0';
   
    
end Behavioral;
