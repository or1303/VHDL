--///////////////////////////////////////////////////////////////////////////
--// MODULE               : forwarding unit	                                           //
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
use ieee.std_logic_signed.all;
----------------------------------------------------
entity forwarding_unit is
port(
	regwrite_mem             : in	std_logic;                       --regwrite from mem (ex/mem reg)
	write_register_mem       : in std_logic_vector(4 downto 0);    -- destination register from mem (ex/mem reg)
	
	regwrite_writeback       : in	std_logic;                       --regwrite from writeback (mem/wb reg)
	write_register_writeback : in std_logic_vector(4 downto 0);    -- destination register from writeback (mem/wb reg)
	
	rs_reg_decode            : in std_logic_vector(4 downto 0);    --rs from decode register
	rt_reg_decode            : in std_logic_vector(4 downto 0);    --rt from decode register
---------------------------------------------------------------------------------------------------------
	mux_control_1            : out std_logic_vector (1 downto 0);  --mux1 control for ex phase
	mux_control_2            : out std_logic_vector (1 downto 0)   --mux2 control for ex phase
	
	
	);
end forwarding_unit ;



architecture forwarding_unit_arc of forwarding_unit  is	

begin

  mux_control_1 <= ("01") when (( regwrite_mem = '1') and ( write_register_mem = rs_reg_decode)) else 
                   ("10") when (( regwrite_writeback = '1') and ( write_register_writeback = rs_reg_decode) and (write_register_mem /= rs_reg_decode )) else	("00");

 mux_control_2 <= ("01") when (( regwrite_mem = '1') and ( write_register_mem = rt_reg_decode)) else 
  
                  ("10") when (( regwrite_writeback = '1') and ( write_register_writeback = rt_reg_decode) and (write_register_mem /= rt_reg_decode)) else
						
						("00");
						
						
 
end forwarding_unit_arc;