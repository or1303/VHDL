--///////////////////////////////////////////////////////////////////////////
--// MODULE               : instruction_decode 	                                           //
--//                                                                       //
--// DESIGNER             : Or meir sofer, Nitzan elimelech       //
--//									   //
--// VHDL code for the instruction decode phase					   //
--// 		   //
--// 									   //
--///////////////////////////////////////////////////////////////////////////


library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

----------------------------------------------------
entity instruction_decode is

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
end instruction_decode;

----------------------------------------------------
architecture instruction_decode_arc of instruction_decode is	


component control is --control unit 
port(	opcode       :	  in std_logic_vector (5 downto 0);
	
			
	memtoreg        :  out	std_logic;
	reg_write_out   :  out	std_logic;
	memwrite        :  out	std_logic;
	memread         :  out	std_logic;
	branch          :  out	std_logic;
	alu_src         :  out	std_logic;
	reg_dst         :  out	std_logic;
	jump	        :  out std_logic;
	alu_op          :	out std_logic_vector (1 downto 0)
    	);
end component control;

component bor is --bank of registers 
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
end component bor;





component id_ex_reg is
port(

  reset      :	  in std_logic;
	clk        :     in std_logic;
	read_data1 :	  in std_logic_vector (31 downto 0);
	read_data2 :     in std_logic_vector (31 downto 0);
	sign_extended :	  in std_logic_vector (31 downto 0);
	pc_next :	  in std_logic_vector (31 downto 0);
	rs_reg:	in std_logic_vector(4 downto 0);
	rt_reg:	in std_logic_vector(4 downto 0);
	rd_reg:	in std_logic_vector(4 downto 0);
	function_in:	in std_logic_vector(5 downto 0);

	
	memtoreg:    in	std_logic;
	reg_write:    in	std_logic;
	memwrite:    in	std_logic;
	memread:    in	std_logic;
	alu_src:    in	std_logic;
	reg_dst:    in	std_logic;
	alu_op:	  in std_logic_vector (1 downto 0);

	
	
	read_data1_out :	  out std_logic_vector (31 downto 0);
	read_data2_out :     out std_logic_vector (31 downto 0);
	sign_extended_out :	  out std_logic_vector (31 downto 0);
	pc_next_out :	  out std_logic_vector (31 downto 0);
	rs_reg_out:	out std_logic_vector(4 downto 0);
	rt_reg_out:	out std_logic_vector(4 downto 0);
	rd_reg_out:	out std_logic_vector(4 downto 0);
	
	function_out:	out std_logic_vector(5 downto 0);
	
	memtoreg_out:    out	std_logic;
	reg_write_out:    out	std_logic;
	memwrite_out:    out	std_logic;
	memread_out:    out	std_logic;
	alu_src_out:    out	std_logic;
	reg_dst_out:    out	std_logic;
	alu_op_out:	  out std_logic_vector (1 downto 0);
---------------------------to fetch--------------------------------

	jump_in         :   in std_logic;
	jump_address_in : in std_logic_vector (31 downto 0);

	pc_src_in         :   in std_logic;
	branch_in       : in std_logic_vector (31 downto 0);

        pc_src_out      : out std_logic;
	branch_out      : out std_logic_vector (31 downto 0);

	jump_out         :   out std_logic;
	jump_address_out       : out std_logic_vector (31 downto 0)


	);
end component;






-------------------SIGNALS------------------------------
signal sign_extended_out_sig : std_logic_vector (31 downto 0);

-------------------control input-----------------------
signal opcode_sig : std_logic_vector (5 downto 0);
signal rs_reg_sig : std_logic_vector (4 downto 0);
signal rt_reg_sig : std_logic_vector (4 downto 0);
signal rd_reg_sig : std_logic_vector (4 downto 0);
signal function_sig : std_logic_vector (5 downto 0);


--------------------control output----------------------
signal memtoreg_control_sig : std_logic; 
signal reg_write_out_control_sig : std_logic; 
signal memwrite_control_sig : std_logic; 
signal memread_control_sig : std_logic; 
signal branch_sig : std_logic; 
signal alu_src_sig : std_logic; 
signal reg_dst_sig : std_logic; 
signal alu_opl_sig : std_logic_vector (1 downto 0); 
signal jump_control_sig : std_logic;

	
-------------------bor output--------------------------
signal read_data1_sig  : std_logic_vector (31 downto 0);
signal read_data2_sig  : std_logic_vector (31 downto 0);

----------------------general-----------------------------
signal reg_data_equal : std_logic; --check if reg data s equal for branch condition
signal address_shifted_left : std_logic_vector (31 downto 0);
signal address_result_sig : std_logic_vector (31 downto 0);
signal pc_src_out_decode_sig : std_logic;
signal jump_address_sig : std_logic_vector (31 downto 0);



begin

-------------------control unit wiring--------------------		
	control_unit : control

	port map(
	
        opcode => opcode_sig ,
	memtoreg => memtoreg_control_sig,
	reg_write_out => reg_write_out_control_sig,
	memwrite =>memwrite_control_sig ,
	memread =>memread_control_sig ,
	branch =>branch_sig ,
	alu_src =>alu_src_sig ,
	reg_dst => reg_dst_sig,
        jump    => jump_control_sig,
	alu_op => alu_opl_sig
   );
-----------------------bor wiring -------------------------
	bank0 : bor
	
	port map(
	clk=>clk,
	reset=>reset,
	reg_write_in => reg_write_in_decode ,
	write_reg =>reg_to_write_in_decode ,
	write_data => data_to_write_in_decode ,
	read_reg1 => rs_reg_sig, --rs
	read_reg2 => rt_reg_sig, --rt
	
	read_data1 => read_data1_sig,
	read_data2 => read_data2_sig
	
	);

	-----------------------register wiring -------------------------

	
	id_ex : id_ex_reg
	
	port map(
	
	reset          => reset,
	clk            => clk,
	read_data1    => read_data1_sig,
 	read_data2    => read_data2_sig,
	sign_extended => sign_extended_out_sig,
	pc_next       => pc_in_decode,
	rs_reg        =>  rs_reg_sig,
	rt_reg        => rt_reg_sig,
 	rd_reg        => rd_reg_sig,
	function_in   => function_sig,

 	
	memtoreg      =>memtoreg_control_sig,
	reg_write     => reg_write_out_control_sig,
	memwrite       => memwrite_control_sig,
	memread      => memread_control_sig,
	alu_src        => alu_src_sig,
	reg_dst       => reg_dst_sig,
	alu_op        => alu_opl_sig,


	
	read_data1_out  => read_data_1_out_decode,
	read_data2_out => read_data_2_out_decode,
	sign_extended_out=> sign_extended_out_decode,
	pc_next_out =>  pc_out_decode,
	rs_reg_out=> rs_reg_out_decode,
	rt_reg_out=> rt_reg_out_decode,
	rd_reg_out=> rd_reg_out_decode,
	
	function_out=> decode_function_out,
	
	memtoreg_out=> memtoreg_out_decode,
	reg_write_out=> reg_write_out_decode,
	memwrite_out=>  memwrite_out_decode,
	memread_out=> memread_out_decode,
	alu_src_out=> alu_src_out_decode,
	reg_dst_out=> reg_dst_out_decode,
	alu_op_out=> alu_op_out_decode,
	
        pc_src_in => pc_src_out_decode_sig,
	branch_in => address_result_sig,

	pc_src_out => pc_src_out_decode,
	branch_out => branch_pc_out_decode,

	jump_in =>  jump_control_sig,
	jump_address_in => jump_address_sig,
	
	jump_out => jump_out_decode,
	jump_address_out => jump_address
	

	
	);

	
	
	
	
        reg_data_equal <= '1' when (read_data1_sig = read_data2_sig) else '0';

	pc_src_out_decode_sig <= reg_data_equal and branch_sig;
	
	rs_reg_sig <= instruction_in_decode(25 downto 21); -- rs address
	rt_reg_sig <= instruction_in_decode(20 downto 16); -- rt address
	rd_reg_sig <= instruction_in_decode (15 downto 11);  --rd address


	sign_extended_out_sig <= "1111111111111111" & instruction_in_decode(15 downto 0) when (instruction_in_decode(15) = '1') else    --sign extend
           "0000000000000000" & instruction_in_decode(15 downto 0) when (instruction_in_decode(15) = '0');
			  
	
	address_shifted_left <= sign_extended_out_sig(29 downto 0) & "00";
		
	address_result_sig <= (address_shifted_left + pc_in_decode);

			  
	
	function_sig <= instruction_in_decode(5 downto 0);
	
	
	opcode_sig <= instruction_in_decode(31 downto 26);
	
	jump_address_sig  <= pc_in_decode(31 downto 28) & instruction_in_decode(25 downto 0) & "00";

end instruction_decode_arc;





