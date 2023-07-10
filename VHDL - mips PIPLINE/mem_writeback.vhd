--///////////////////////////////////////////////////////////////////////////
--// MODULE               : mem_wb REGISTER	                                           //
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
entity mem_writeback is
port(
	reset                    : in std_logic;
	clk                      : in std_logic;
	Alu_result               : in std_logic_vector (31 downto 0);  --alu result - depends on function
	read_data                : in std_logic_vector(31 downto 0);   --data from dmem
   register_to_write        : in std_logic_vector(4 downto 0);    -- destination reg for r instructions
	reg_write                : in	std_logic;                       --regwrite from control to writeback
	memtoreg                 : in	std_logic;                       -- memtoregfrom control to writeback
---------------------------------------------------------------------------------------------------------
	Alu_result_out           : out std_logic_vector (31 downto 0); --alu result - depends on function
	read_data_out            : out std_logic_vector (31 downto 0); --data from dmem
	register_to_write_out    :	out std_logic_vector(4 downto 0);   -- destination reg for r instructions
	
	memtoreg_out:    out	std_logic;                                -- memtoregfrom control to writeback
	reg_write_out:    out	std_logic                          --regwrite from control to writeback
	
	);
end mem_writeback ;

architecture mem_writeback_arc of mem_writeback  is	
begin
 process (clk,reset)
	begin

	if (reset= '1') then
		Alu_result_out        <= (others => '0');
		read_data_out         <= (others => '0');
		register_to_write_out <= (others => '0');
	
		memtoreg_out <= '0';
		reg_write_out<= '0';
		
		
   elsif rising_edge(clk) then
		
		Alu_result_out <= Alu_result;
		read_data_out <= read_data;
		register_to_write_out <= register_to_write;
	
		memtoreg_out <= memtoreg;
		reg_write_out<= reg_write;
		
	end if;
	
	end process;
 
end mem_writeback_arc;