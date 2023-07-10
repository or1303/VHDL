--///////////////////////////////////////////////////////////////////////////
--// MODULE               : control                                        //
--//                                                                       //
--// DESIGNER             : Or_Meir_Sofer && Nitzan_Elimelech              //
--//								                                          	   //                 
--// VHDL code for ALU                                                     //
--//                                                  			            //
--// 				                                            					   //
--///////////////////////////////////////////////////////////////////////////


library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------
entity control is


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
end control;
----------------------------------------------------
architecture control_arc of control is		 	  
	signal result_vector: std_logic_vector (9 downto 0);
	
	begin
	
	
   result_vector <= ("0110000010") when (opcode = "000000") else                -- for r format instructions
		    ("0000101011") when (opcode = "100011") else                -- for lw instructions
		    ("0000100100") when (opcode = "101011") else                -- for sw instructions 
		    ("0001010000") when (opcode = "000100") else                -- for beq instructions
		    ("0000100010") when (opcode = "001000") else                -- for addi type instructions
         	    ("1000000000") when (opcode = "000010") else                -- for jump type instructions
		     ("0000000000");  
						  
--------------------------------------assigning outputs from result vector-----------------------------
	memtoreg <= result_vector(0);
	reg_write_out <= result_vector(1); 
	memwrite <= result_vector(2); 
	memread <= result_vector(3); 
	branch <= result_vector(4); 
	alu_src <= result_vector(5); 
	alu_op(0) <= result_vector(6);
	alu_op(1) <= result_vector(7);
	reg_dst <= result_vector(8);
	jump <= result_vector(9); 
	
end control_arc;