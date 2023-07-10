--///////////////////////////////////////////////////////////////////////////
--// MODULE               : if_id REGISTER	                                           //
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
entity if_id_reg is
port(  
	pc_in:	  in std_logic_vector (31 downto 0);
	instruction_in : in std_logic_vector (31 downto 0);
	reset:	  in std_logic;
	clk: in std_logic;
	pc_out :	out std_logic_vector (31 downto 0);
	
	instruction_out : out std_logic_vector (31 downto 0)

	);
end if_id_reg;

architecture if_id_reg_arc of if_id_reg is	
begin
 process (clk,reset)
	begin

	if (reset= '1') then
		pc_out <= (others => '0');
		instruction_out <= (others =>'0');
		
   elsif rising_edge(clk) then
		pc_out <= pc_in;
		instruction_out <= instruction_in;
	end if;
	
	end process;
 
end if_id_reg_arc;



