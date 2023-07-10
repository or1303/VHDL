--///////////////////////////////////////////////////////////////////////////
--// MODULE               : id_ex REGISTER	                                           //
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
use IEEE.std_logic_unsigned.all;
----------------------------------------------------
entity id_ex_reg is
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
	branch_in         : in std_logic_vector (31 downto 0);

        pc_src_out         : out std_logic;
	branch_out         : out std_logic_vector (31 downto 0);

	jump_out            :   out std_logic;
	jump_address_out    : out std_logic_vector (31 downto 0)



	);
end id_ex_reg;

architecture id_ex_reg_arc of id_ex_reg is	
begin
  process (clk,reset)
	begin
	if (reset= '1') then

		
		read_data1_out <= (others => '0');
		read_data2_out <= (others => '0');
		sign_extended_out <= (others => '0');
		pc_next_out 	 <= (others => '0');
		rs_reg_out<= (others => '0');
		rd_reg_out <= (others => '0');
		rt_reg_out <= (others => '0');
		function_out<= (others => '0');
		alu_op_out <= (others => '0');

		memtoreg_out <= '0';
		reg_write_out<= '0';
		memwrite_out <= '0';
		memread_out <= '0';
		alu_src_out <= '0';
		reg_dst_out <= '0';
		
		pc_src_out <= '0';
	        branch_out <= (others => '0');    
	        jump_out  <= '0';       
	        jump_address_out <= (others => '0');       

               elsif rising_edge(clk) then

		read_data1_out <= read_data1;
		read_data2_out <= read_data2;
		sign_extended_out <= sign_extended;
		pc_next_out 	 <= pc_next;
		rd_reg_out <= rd_reg;
		rt_reg_out <= rt_reg;
		rs_reg_out <= rs_reg;
		function_out <= function_in;
	
		memtoreg_out <= memtoreg;
		reg_write_out<= reg_write;
		memwrite_out <= memwrite;
		memread_out <= memread;
		alu_src_out <= alu_src;
		reg_dst_out <= reg_dst;
		alu_op_out <= alu_op;
		
		pc_src_out <= pc_src_in;
	        branch_out <= branch_in;
	        jump_out  <=   jump_in;
	        jump_address_out <= jump_address_in;
	      end if;
	
	end process;
 
end id_ex_reg_arc;