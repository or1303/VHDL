--///////////////////////////////////////////////////////////////////////////
--// MODULE               : memory_phase                                  //
--//                                                                       //
--// DESIGNER             : Or_Meir_Sofer && Nitzan_Elimelech              //
--//								                                          	   //                 
--// VHDL code for memory_phase                                                     //
--//                                                  			            //
--// 				                                            					   //
--///////////////////////////////////////////////////////////////////////////


library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity memory_phase is

port(	
-----------------------general input or from ex-----------------------------------------------
      alu_result           : in  std_logic_vector(31 downto 0); --alu result - depends on function
      reset                : in  std_logic; -- reset signal
	   clk                  : in  std_logic; -- clk
		alu_zero_bit         : in  std_logic; -- for branching
		memwrite             : in	std_logic; -- memwrite from control
	   memread              : in	std_logic; --memread from control
		reg_write            : in	std_logic; --regwrite from control to writeback
		memtoreg             : in	std_logic; -- memtoregfrom control to writeback
		register_to_write_in : in  std_logic_vector(4 downto 0); --regdestination to writeback
		write_data_in        : in  std_logic_vector (31 downto 0); -- data from reg2 to writte to dmem


		
-----------------------datapath out--------------------------------------------------------

      register_to_write_out    : out std_logic_vector(4 downto 0);   -- destination reg for r instructions
		alu_result_out       : out std_logic_vector(31 downto 0);  --alu result - depends on function
		read_data_out        : out std_logic_vector(31 downto 0);  --data from dmem
		reg_write_out        : out	std_logic;                      --regwrite from control to writeback
		memtoreg_out         : out	std_logic;                      -- memtoregfrom control to writeback
	                          
		
-------------------------to hazard unit--------------------------		
      register_to_write_hazard    : out std_logic_vector(4 downto 0);
      alu_result_hazard           : out std_logic_vector(31 downto 0);
		reg_write_hazard            : out	std_logic --regwrite from control to writeback
		
	  );
		end memory_phase;
		
		
architecture memory_phase_arc of memory_phase is

component dmem is --data memory unit 
 port ( 
		clk        : in  std_logic;
		rst        : in  std_logic;
		address    : in  std_logic_vector(31  downto 0);
		-- write side
		mem_write  : in  std_logic;
		write_data : in  std_logic_vector(31 downto 0);
		-- read side
		mem_read   : in  std_logic;
		read_data  : out std_logic_vector(31 downto 0)	
	  );
end component dmem;



component mem_writeback is
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
	reg_write_out:    out	std_logic                              --regwrite from control to writeback
	
	);
end component mem_writeback ;


-----------signals-------------------------------------------
signal read_data_out_sig : std_logic_vector(31 downto 0);
begin


	data_memory : dmem

	port map(
   clk => clk,
	rst => reset,
	address => alu_result,
	mem_write => memwrite,
	write_data => write_data_in,
	mem_read => memread,
	read_data => read_data_out_sig
   );
	
	
	
	mem_writebac : mem_writeback

	port map(
   clk => clk,
	reset => reset,
	Alu_result => alu_result,
	read_data => read_data_out_sig ,
	register_to_write => register_to_write_in,
	reg_write => reg_write,
	memtoreg => memtoreg,
	Alu_result_out => alu_result_out,
	read_data_out => read_data_out,
	register_to_write_out => register_to_write_out,
	memtoreg_out => memtoreg_out,
	reg_write_out => reg_write_out
   );
	
	  
	  
	  register_to_write_hazard <= register_to_write_in;
     
	  alu_result_hazard <= alu_result;
	  
	  reg_write_hazard <= reg_write;

	
end  memory_phase_arc;