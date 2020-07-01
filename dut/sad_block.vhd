--Stefan Stankovic EE17-2015
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

	bref_data_in: in std_logic_vector(W_DATA-1 downto 0);
	bref_address_out:out std_logic_vector(W_ADDRESS-1 downto 0);
	---------------BRAM_current--------------------------------
	bcurr_data_in: in std_logic_vector(W_DATA-1 downto 0);
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
	type state_type is (idle,s1,s2,s3);
	signal state_reg,state_next:state_type;	
	signal i_reg,i_next: unsigned(W_ADDRESS-1 downto 0); 
	signal j_reg,j_next: unsigned(W_ADDRESS-1 downto 0);
	signal err_reg,err_next: unsigned(log2c(256*(MB_SIZE*MB_SIZE))-1 downto 0);
	
    constant BLOCK_SIZE:integer:=(MB_SIZE-1);
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

    elsif(clk'event and clk='1') then
		state_reg<=state_next;
		i_reg<=i_next;
		j_reg<=j_next;
		err_reg<=err_next;

    end if;
  end process;

--comb
  process (	state_reg,
			i_reg,
			j_reg,
			err_reg,
			start, 
			bcurr_data_in, 
			bref_data_in,  
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
		
	case state_reg is
        when idle =>
            ready <= '1';
			err_out<=std_logic_vector(err_reg);
            if(start='1') then
                i_next   <= (others=>'0');
				j_next   <= (others=>'0');
				err_next   <= (others=>'0');
                state_next<=s1;
            else
                state_next<=idle;
            end if;
        when s1=>
            j_next<=(others=>'0');
            state_next<=s2;
        when s2=>
            --not parameterized, it works only for 128,256,512,1024 pix, for ROW
            bcurr_address_out<=std_logic_vector(unsigned(shift_left(unsigned(i_reg+unsigned(i_curr_in)),log2c(ROW_SIZE)))+unsigned(j_reg+unsigned(j_curr_in)));-- nije parametrizovano
			bref_address_out<=std_logic_vector(unsigned(shift_left(unsigned(i_reg+unsigned(i_ref_in)),log2c(ROW_SIZE)))+unsigned(j_reg+unsigned(j_ref_in)));			  
            
            --THIS IS parameterized BUT NOT WORKING
            --bcurr_address_out<=std_logic_vector( to_unsigned(to_integer((to_unsigned(ROW_SIZE,log2c(ROW_SIZE))*(i_reg+unsigned(i_curr_in)))+(j_reg+unsigned(j_curr_in))),W_ADDRESS));
            --bref_address_out<=std_logic_vector( to_unsigned(to_integer((to_unsigned(ROW_SIZE,log2c(ROW_SIZE))*(i_reg+unsigned(i_ref_in)))+(j_reg+unsigned(j_ref_in))),W_ADDRESS));
           state_next<=s3;
	     when s3=>  
			err_next<=err_reg+to_unsigned(to_integer(abs(to_signed(to_integer(unsigned(bcurr_data_in)),W_DATA+1)- to_signed(to_integer(unsigned(bref_data_in)),W_DATA+1))),log2c(MAX_ERR_VAL));
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
	           state_next<=s2;
	       end if;
      end case;
    end process;	
end architecture;
--Stankovic Stefan EE17/2015