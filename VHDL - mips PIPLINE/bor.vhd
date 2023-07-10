library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bor is
 port ( 
		clk        : in  std_logic;
		reset        : in  std_logic;
		-- write side
		reg_write_in  : in  std_logic;
		write_reg  : in  std_logic_vector(4  downto 0);
		write_data : in  std_logic_vector(31 downto 0);
		-- read side
		read_reg1  : in  std_logic_vector(4  downto 0);
		read_reg2  : in  std_logic_vector(4  downto 0);
		read_data1 : out std_logic_vector(31 downto 0);
		read_data2 : out std_logic_vector(31 downto 0)		
	  );
end entity bor;

architecture arc_bor of bor is
type reg_arr is array (natural range <>) of std_logic_vector(write_data'range);
signal regs: reg_arr((2**write_reg'length) -1 downto 0);
begin
	process(clk,reset) is
	begin
		if (reset='1') then
			regs      <=(others=>(others=>'0'));
			read_data1<=(others=>'0');
			read_data2<=(others=>'0');
		elsif rising_edge(clk) then
			if(reg_write_in='1' and write_reg/=0) then
			  regs(conv_integer(write_reg))<=write_data;
			end if;
    	end if;	
			read_data1<=regs(conv_integer(read_reg1));
			read_data2<=regs(conv_integer(read_reg2));
	end process; 

end architecture arc_bor;	  