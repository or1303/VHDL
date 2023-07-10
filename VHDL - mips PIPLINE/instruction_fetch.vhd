--///////////////////////////////////////////////////////////////////////////
--// MODULE               : instruction_fetch 	                                           //
--//                                                                       //
--// DESIGNER             : Or meir sofer, Nitzan elimelech       //
--//									   //
--// VHDL code for the instruction fetch phase					   //
--// 		   //
--// 									   //
--///////////////////////////////////////////////////////////////////////////


library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
----------------------------------------------------
entity instruction_fetch is

port(
	pc_src          : in  std_logic;
	pc_in           : in std_logic_vector(31 downto 0); 
	reset           : in std_logic;
	clk             : in std_logic;		
	jump_in         : in std_logic;
	jump_address     : in std_logic_vector (31 downto 0 );
	
	pc_out_if          : out std_logic_vector (31 downto 0);
	instruction_out_if : out std_logic_vector ( 31 downto 0)
	);
end instruction_fetch;

----------------------------------------------------
architecture instruction_fetch_arc of instruction_fetch is	
	 	  
	component pc_register is --pc register
	port(
	pc_in_reg:	  in std_logic_vector (31 downto 0);
	reset:	  in std_logic;
	clk: in std_logic;
	pc_out_reg :	out std_logic_vector (31 downto 0)
	);
	end component pc_register;
	
	
	component imem is
	port ( pc:    in  std_logic_vector(31 downto 0);
       instr: out std_logic_vector(31 downto 0)
	  );
	end component imem;

	component if_id_reg is
   port(
	pc_in:	  in std_logic_vector (31 downto 0);
	instruction_in : in std_logic_vector (31 downto 0);
	reset:	  in std_logic;
	clk: in std_logic;
	pc_out :	out std_logic_vector (31 downto 0);
	
	instruction_out : out std_logic_vector (31 downto 0)

	);
   end component if_id_reg;
	

	SIGNAL current_pc : STD_LOGIC_vector (31 downto 0); -- the current pc to work with (add 4, fetch instruction from memory)
	SIGNAL muxed_pc : STD_LOGIC_vector (31 downto 0);   -- pc after mux - to enter pc register               
	signal added_pc: STD_LOGIC_vector (31 downto 0);    -- pc_reg out +4      
	signal instruction_sig : std_logic_vector (31 downto 0);
	signal pc_to_pc_reg : std_logic_vector(31 downto 0);
	signal reset_sig : std_logic;
	
begin

		
	pc : pc_register
	
	port map(
	pc_in_reg => pc_to_pc_reg,
	clk => clk,
	reset => reset,
	pc_out_reg => current_pc
	);
	
	
	instruction_memory : imem 
	
	port map(
	 pc=> current_pc,
	 instr => instruction_sig
	
	);
	
	if_id : if_id_reg
   port map(
	
	pc_in => added_pc,
	instruction_in => instruction_sig,
	reset => reset_sig,  
	clk => clk,
	pc_out => pc_out_if,
	
	instruction_out => instruction_out_if

	);

	
	added_pc <= conv_std_logic_vector((conv_integer(current_pc) + 4),32);

	muxed_pc <= pc_in when pc_src ='1' else added_pc;
	
	pc_to_pc_reg <= jump_address when jump_in = '1' else muxed_pc;
	
	reset_sig <= reset or jump_in or pc_src;
	
end instruction_fetch_arc;




