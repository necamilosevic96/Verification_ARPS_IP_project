--Stankovic Stefan EE17/2015
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity BRAM is
	generic(
		W_DATA: natural:=8;
		W_ADDRESS: natural:=16
	);
	port(
		clk_a  : in  std_logic;
		clk_b  : in  std_logic;
		en_a   : in  std_logic;
		en_b   : in  std_logic;
		we_a   : in  std_logic;
		we_b   : in  std_logic;
		addr_a : in  std_logic_vector(W_ADDRESS-1 downto 0);
		addr_b : in  std_logic_vector(W_ADDRESS-1 downto 0);
		di_a   : in  std_logic_vector(W_DATA-1 downto 0);
		di_b   : in  std_logic_vector(W_DATA-1 downto 0);
		do_a   : out std_logic_vector(W_DATA-1 downto 0);
		do_b   : out std_logic_vector(W_DATA-1 downto 0)
 );
end BRAM;

architecture Behavioral of BRAM is
 type ram_type is array (0 to 2**W_ADDRESS-1) of std_logic_vector(W_DATA-1 downto 0);
 shared variable RAM : ram_type:=(others=>(others=>'0'));
begin
 process(CLK_A)
 begin
  if CLK_A'event and CLK_A = '1' then
   if EN_A = '1' then
    DO_A <= RAM(to_integer(unsigned(ADDR_A)));
    if WE_A = '1' then
     RAM(to_integer(unsigned(ADDR_A))) := DI_A;
    end if;
	 end if;
  end if;
 end process;
 
 process(CLK_B)
 begin
  if CLK_B'event and CLK_B = '1' then
   if EN_B = '1' then
    DO_B <= RAM(to_integer(unsigned(ADDR_B)));
    if WE_B = '1' then
     RAM(to_integer(unsigned(ADDR_B))) := DI_B;
    end if;
   end if;
  end if;
 end process;
end architecture Behavioral;
--Stankovic Stefan EE17/2015