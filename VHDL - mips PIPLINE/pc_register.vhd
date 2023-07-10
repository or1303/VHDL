--///////////////////////////////////////////////////////////////////////////
--// MODULE               : PC REGISTER	                                           //
--//                                                                       //
--// DESIGNER             : Or meir sofer, Nitzan elimelech       //
--//									   //
--// VHDL code for n-bit counter 					   //
--// this is the behavior description of n-bit counter			   //
--// 									   //
--///////////////////////////////////////////////////////////////////////////


library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
----------------------------------------------------
entity pc_register is
port(
	pc_in_reg:	  in std_logic_vector (31 downto 0);
	reset:	  in std_logic;
	clk: in std_logic;
	pc_out_reg :	out std_logic_vector (31 downto 0)
	);
end pc_register;

architecture pc_register_arc of pc_register is	
begin
 process (clk,reset)
	begin

	if (reset= '1') then
		pc_out_reg <= (others => '0');
   elsif rising_edge(clk) then
		pc_out_reg <= pc_in_reg;
	
	end if;
	
	end process;
 
end pc_register_arc;



