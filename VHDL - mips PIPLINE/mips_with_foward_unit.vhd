--///////////////////////////////////////////////////////////////////////////
--// MODULE               : mips_integrated_no_units 	                                           //
--//                                                                       //
--// DESIGNER             : Or meir sofer, Nitzan elimelech       //
--//									   //
--// VHDL code for the instruction decode phase					   //
--// 		   //
--// 									   //
--///////////////////////////////////////////////////////////////////////////


library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------
entity mips_with_foward_unit is

port(
	 reset           :    in std_logic; --active high!
	 clk             :    in std_logic

	 );
end mips_with_foward_unit;

----------------------------------------------------
architecture mips_with_foward_unit_arc of mips_with_foward_unit is	


component instruction_fetch is ---instruction fetch phase

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
end component instruction_fetch;

component instruction_decode is ---instruction decode phase

port(
      reset                      : in std_logic;
	  clk                        : in std_logic;
	  instruction_in_decode      : in std_logic_vector (31 downto 0);
	  pc_in_decode               : in std_logic_vector (31 downto 0);
	  
	  reg_write_in_decode        : in std_logic;
	  reg_to_write_in_decode     : in std_logic_vector (4 downto 0);
	  data_to_write_in_decode    : in std_logic_vector (31 downto 0);
	  
	  rs_reg_out_decode          : out std_logic_vector (4 downto 0);
	  rt_reg_out_decode          : out std_logic_vector (4 downto 0);
	  rd_reg_out_decode          : out std_logic_vector (4 downto 0);
	  sign_extended_out_decode   : out std_logic_vector (31 downto 0);
          jump_address               : out std_logic_vector (31 downto 0);
          
          
	  
	  
	  
	   read_data_1_out_decode    : out std_logic_vector (31 downto 0);
		read_data_2_out_decode    : out std_logic_vector (31 downto 0);
		pc_out_decode             : out std_logic_vector (31 downto 0);
	  
	   decode_function_out        : out std_logic_vector (5 downto 0);
	  
	   memtoreg_out_decode     :   out	std_logic;
	   reg_write_out_decode    :   out	std_logic;
	   memwrite_out_decode     :   out	std_logic;
	   memread_out_decode      :   out	std_logic;
	   jump_out_decode         :   out      std_logic;
    
	   pc_src_out_decode       :   out	std_logic;
   	   branch_pc_out_decode    :   out  std_logic_vector (31 downto 0);
		
	   alu_src_out_decode      :   out	std_logic;
	   reg_dst_out_decode      :   out	std_logic;
	   alu_op_out_decode       :	 out std_logic_vector (1 downto 0)
          
	 );
end component instruction_decode;




component Execute is --execute phase

port(	
--------------general input or from id------------------------

      reset             : in  std_logic;
		clk               : in  std_logic;
		alu_op            : in  std_logic_vector(1 downto 0);   -- alu op from control
		function_in       : in  std_logic_vector(5 downto 0);   -- function from instruction
	   read_data_1       : in  std_logic_vector (31 downto 0); -- data from reg1 
	   read_data_2_in    : in  std_logic_vector (31 downto 0); -- data from reg2
		sign_extended_in  : in  std_logic_vector (31 downto 0); -- sighk
		pc_in             : in  std_logic_vector (31 downto 0); -- next pc
		alu_src           : in  std_logic;                      -- alu source in
		reg_dst           : in	 std_logic;                     -- reg destination from control 
		rs_reg            : in  std_logic_vector(4 downto 0);
		rt_reg            : in  std_logic_vector(4 downto 0);
		rd_reg            : in  std_logic_vector(4 downto 0);
	   memtoreg          : in	std_logic;
	   reg_write         : in	std_logic;
     	memwrite          : in	std_logic;
    	memread           : in	std_logic;
		mem_forward       : in  std_logic_vector (31 downto 0); -- data from mem_phase for alu
		writeback_forward : in  std_logic_vector (31 downto 0); -- data from writeback_phase for alu
		forward_mux_1     : in  std_logic_vector (1 downto 0);  -- forward mux control 1
		forward_mux_2     : in  std_logic_vector (1 downto 0);  -- forward mux control 2 

		
--------------outputs-----------------------------------------
		alu_result        : out std_logic_vector(31 downto 0);
		register_to_write : out std_logic_vector(4 downto 0);
		alu_zero_out      : out std_logic;
		alu_set_less_than : out std_logic;                     -- SLT -->for slt instructions
		read_data_2_out   : out std_logic_vector (31 downto 0); -- data from reg2 
		rs_reg_out            : out  std_logic_vector(4 downto 0);

		
		
	   memtoreg_out      : out	std_logic;
	   reg_write_out     : out	std_logic;
     	memwrite_out      : out	std_logic;
    	memread_out       : out	std_logic
		
		
		
		
		
	  );
		end component Execute;


component memory_phase is

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
		end component memory_phase;

		
	component writeback is
  port(
	Alu_result               : in std_logic_vector (31 downto 0);  --alu result - depends on function
	read_data                : in std_logic_vector (31 downto 0);  --data from dmem
	memtoreg                 : in	std_logic;                       --memtoregfrom control to writeback
---------------------------------------------------------------------------------------------------------
	writeback_out            : out std_logic_vector (31 downto 0);   --alu result - depends on function
	writeback_hazard         : out std_logic_vector (31 downto 0) --forwarding data

	
	);
  end component writeback ;	
		
		

component forwarding_unit is
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
end component forwarding_unit ;
















-------------------SIGNALS----------------------------------------

-------------------if output--------------------------------------
	signal pc_out_if_sig             :	  std_logic_vector (31 downto 0);
	signal instruction_out_if_sig    :    std_logic_vector (31 downto 0);
--------------------decode output--------------------------------- 
	signal memtoreg_decode_out_sig   :	  std_logic;
	signal reg_write_out_decode_sig  :	  std_logic;
        signal memwrite_decode_out_sig   :	  std_logic;
	signal memread_decode_out_sig    :	  std_logic;
        signal jump_out_decode_sig       :        std_logic;
	signal jump_address_sig          :        std_logic_vector (31 downto 0);
	signal alu_src_decode_out_sig    :	  std_logic;
	signal reg_dst_decode_out_sig    :	  std_logic;
	signal alu_op_decode_out_sig     :	  std_logic_vector (1 downto 0);
	
   signal pc_out_decode_sig                   :	 std_logic_vector (31 downto 0);
	signal read_data_1_decode_out_sig          :    std_logic_vector (31 downto 0); -- data from reg to next phase
	signal read_data_2_decode_out_sig          :    std_logic_vector (31 downto 0); -- data from reg to next phase
	signal sign_ext_out_decode_sig              :    std_logic_vector (31 downto 0); -- sign extended adress/offset
	signal function_out_decode_sig             :    std_logic_vector (5  downto 0); -- function to alu control
	signal rs_reg_out_decode_out_decode_sig    :    std_logic_vector (4 downto 0) ; -- register1 address out
	signal rt_reg_out_decode_out_decode_sig    :    std_logic_vector (4 downto 0) ; -- register2 address out
	signal rd_reg_out_decode_out_decode_sig    :    std_logic_vector (4 downto 0) ; -- register2 address out
	signal pc_src_decode_out_sig               :    std_logic;                      --for branch
	signal branch_pc_to_fetch_decode_out_sig   :    std_logic_vector(31 downto 0);
	

-------------------execute output--------------------------------------
	signal alu_result_exec_out_sig        :  std_logic_vector(31 downto 0);
	signal register_to_write_exec_out_sig :  std_logic_vector(4 downto 0);
	signal address_result_exec_out_sig    :  std_logic_vector(31 downto 0);
	signal alu_zero_out_exec_out_sig      :  std_logic;
	signal alu_set_less_than_exec_out_sig :  std_logic;                     -- SLT -->for slt instructions
	signal read_data_2_exec_out_sig       :  std_logic_vector (31 downto 0); -- data from reg2 
	signal memtoreg_exec_out_sig          : 	std_logic;
	signal reg_write_exec_out_sig         : 	std_logic;
   signal memwrite_exec_out_sig          : 	std_logic;
   signal memread_exec_out_sig           : 	std_logic;
----------------------memory output--------------------------------
   signal register_to_write_mem_out_sig    :  std_logic_vector(4 downto 0);   -- destination reg for r instructions
	signal alu_result_mem_out_sig           :  std_logic_vector(31 downto 0);  --alu result - depends on function
	signal read_data_mem_out_sig            :  std_logic_vector(31 downto 0);  --data from dmem
	signal reg_write_mem_out_sig            :  std_logic;                      --regwrite from control to writeback
	signal memtoreg_mem_out_sig             :  std_logic;                      -- memtoregfrom control to writeback
	

	signal register_to_write_hazard_mem_sig     :  std_logic_vector(4 downto 0);
	signal alu_result_hazard_mem_sig            :  std_logic_vector(31 downto 0);
	signal reg_write_hazard_mem_sig             : std_logic;
	


----------------------writeback output-----------------------------
	signal writeback_mem_out_sig        :  std_logic_vector (31 downto 0);  --alu result - depends on function
	signal writeback_hazard_sig         :  std_logic_vector (31 downto 0); --forwarding data

----------------------forwarding unit output-----------------------------
	signal mux_control_1_sig :std_logic_vector (1 downto 0);
	signal mux_control_2_sig :std_logic_vector (1 downto 0);
	
	
------------------------END SIGNALS---------------------------

begin

-------------------instruction fetch wiring--------------------		
	fetch : instruction_fetch
port map(
	pc_src => pc_src_decode_out_sig,         
	pc_in  => branch_pc_to_fetch_decode_out_sig,  
	jump_in  => jump_out_decode_sig,
	jump_address => jump_address_sig,
	reset => reset,         
	clk => clk,           	
	pc_out_if => pc_out_if_sig,
	instruction_out_if => instruction_out_if_sig
	);
	
-----------------------instruction decode wiring ----------------------------------------------------------
	decode : instruction_decode
	
	port map(
     reset                   => reset,   
	  clk                     => clk,
	  instruction_in_decode   => instruction_out_if_sig,
	  pc_in_decode            => pc_out_if_sig,
	  
	  reg_write_in_decode     => reg_write_mem_out_sig,
	  reg_to_write_in_decode  =>  register_to_write_mem_out_sig,
	  data_to_write_in_decode =>  writeback_mem_out_sig, 
	  
	  rs_reg_out_decode         => rs_reg_out_decode_out_decode_sig,     
	  rt_reg_out_decode         => rt_reg_out_decode_out_decode_sig,
	  rd_reg_out_decode         => rd_reg_out_decode_out_decode_sig,
	  sign_extended_out_decode  => sign_ext_out_decode_sig,
	  jump_address              => jump_address_sig,

	  
	   pc_src_out_decode       => pc_src_decode_out_sig,
      branch_pc_out_decode    => branch_pc_to_fetch_decode_out_sig,
	  
	  
	   read_data_1_out_decode    => read_data_1_decode_out_sig,
		read_data_2_out_decode    => read_data_2_decode_out_sig,
		pc_out_decode             => pc_out_decode_sig,
	  
	   decode_function_out       =>function_out_decode_sig,
	  
	   memtoreg_out_decode     => memtoreg_decode_out_sig,
	   reg_write_out_decode    => reg_write_out_decode_sig,
	   memwrite_out_decode     => memwrite_decode_out_sig,
	   memread_out_decode     =>  memread_decode_out_sig,
           jump_out_decode        =>  jump_out_decode_sig,
	   alu_src_out_decode     =>  alu_src_decode_out_sig,
	   reg_dst_out_decode     =>  reg_dst_decode_out_sig,
	   alu_op_out_decode      =>  alu_op_decode_out_sig
	   
	 );

--------------------------------execute wiring ---------------------------------------------------
	execute_phase : Execute

	port map(	
--------------general input or from id------------------------
      reset            => reset,
		clk              => clk,
		alu_op           => alu_op_decode_out_sig,
		function_in      => function_out_decode_sig,
	   read_data_1      => read_data_1_decode_out_sig,
	   read_data_2_in   => read_data_2_decode_out_sig,
		pc_in            => pc_out_decode_sig,
		alu_src          => alu_src_decode_out_sig,
		reg_dst          => reg_dst_decode_out_sig,
		rs_reg           => rs_reg_out_decode_out_decode_sig,
		rd_reg           => rd_reg_out_decode_out_decode_sig,
		rt_reg           => rt_reg_out_decode_out_decode_sig,
		
	   sign_extended_in =>sign_ext_out_decode_sig,
		
	   memtoreg         => memtoreg_decode_out_sig,
	   reg_write        => reg_write_out_decode_sig,
     	memwrite         => memwrite_decode_out_sig,
    	memread          => memread_decode_out_sig,
		mem_forward      => alu_result_hazard_mem_sig,
		writeback_forward => writeback_hazard_sig,
		forward_mux_1    => mux_control_1_sig,
		forward_mux_2    => mux_control_2_sig,
--------------outputs-----------------------------------------
		alu_result        => alu_result_exec_out_sig,
		register_to_write => register_to_write_exec_out_sig,
		alu_zero_out      => alu_zero_out_exec_out_sig,
		alu_set_less_than => alu_set_less_than_exec_out_sig,
		read_data_2_out   => read_data_2_exec_out_sig,
		
	   memtoreg_out      => memtoreg_exec_out_sig,
	   reg_write_out     => reg_write_exec_out_sig,
     	memwrite_out      => memwrite_exec_out_sig,
    	memread_out       => memread_exec_out_sig		
	  );
--------------------------------mem phase wiring ---------------------------------------------------
 memphase : memory_phase

	port map(	
---------general input or from ex-------------------
      reset                => reset,
	   clk                  => clk,
		alu_result           => alu_result_exec_out_sig,
		alu_zero_bit         => alu_zero_out_exec_out_sig,
		memwrite             => memwrite_exec_out_sig,
	   memread              => memread_exec_out_sig,
		reg_write            => reg_write_exec_out_sig,
		memtoreg             => memtoreg_exec_out_sig,
		register_to_write_in => register_to_write_exec_out_sig,
		write_data_in        => read_data_2_exec_out_sig,
-----------------------outputs-----------------------------
      register_to_write_out=> register_to_write_mem_out_sig,
		alu_result_out       => alu_result_mem_out_sig,
		read_data_out        => read_data_mem_out_sig,
		reg_write_out        => reg_write_mem_out_sig,
		memtoreg_out         => memtoreg_mem_out_sig,
		
		register_to_write_hazard  =>  register_to_write_hazard_mem_sig,
      alu_result_hazard         =>  alu_result_hazard_mem_sig,
		reg_write_hazard          =>  reg_write_hazard_mem_sig
		
		
	  );

--------------------------------writeback wiring -----------------------------------------
 writeback_phase : writeback
 
 port map(
	Alu_result              => alu_result_mem_out_sig,
	read_data               => read_data_mem_out_sig,
	memtoreg                => memtoreg_mem_out_sig,
   --------------------------------------------------------
	writeback_out           => writeback_mem_out_sig,
	writeback_hazard        => writeback_hazard_sig
	
	);
	
	
	
--------------------------control unit wiring ------------------------------------------

 foward_unit : forwarding_unit

port map(
	regwrite_mem             =>  reg_write_hazard_mem_sig, 
	write_register_mem       =>  register_to_write_hazard_mem_sig,
	
	regwrite_writeback       =>  reg_write_mem_out_sig,
	write_register_writeback =>  register_to_write_mem_out_sig,
	
	rs_reg_decode            =>  rs_reg_out_decode_out_decode_sig,
	rt_reg_decode            =>  rt_reg_out_decode_out_decode_sig,
---------------------------------------------------------------------------------------------------------
	mux_control_1            => mux_control_1_sig,
	mux_control_2            => mux_control_2_sig
	
	
	);

   



	
end mips_with_foward_unit_arc;




