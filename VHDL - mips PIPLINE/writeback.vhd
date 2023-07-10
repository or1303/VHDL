--///////////////////////////////////////////////////////////////////////////
--// MODULE               : writeback	                                           //
--//                                                                       //
--// DESIGNER             : Or meir sofer, Nitzan elimelech       //
--//									   //
--// 				   //
--//			   //
--// 									   //
--///////////////////////////////////////////////////////////////////////////

		
	
library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
----------------------------------------------------
entity writeback is
port(
	Alu_result               : in std_logic_vector (31 downto 0);  --alu result - depends on function
	read_data                : in std_logic_vector (31 downto 0);  --data from dmem
	memtoreg                 : in	std_logic;                       --memtoregfrom control to writeback
---------------------------------------------------------------------------------------------------------
	writeback_out            : out std_logic_vector (31 downto 0);  --alu result - depends on function
	writeback_hazard         : out std_logic_vector (31 downto 0)
	
	
	);
end writeback ;

architecture writeback_arc of writeback  is	

signal writeback_out_sig : std_logic_vector (31 downto 0);

begin

 writeback_out_sig <= read_data when memtoreg = '1' else Alu_result ;
 writeback_out <= writeback_out_sig;
 writeback_hazard <= writeback_out_sig;
 
end writeback_arc;