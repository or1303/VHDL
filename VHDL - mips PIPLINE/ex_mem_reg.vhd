--///////////////////////////////////////////////////////////////////////////
--// MODULE               : ex_mem REGISTER	                              //
--//                                                                       //
--// DESIGNER             : Or meir sofer, Nitzan elimelech                //
--//						                                          			   //
--// VHDL code for ex_mem REGISTER 					                           //
--// 			                                                               //
--// 						                                            			   //
--///////////////////////////////////////////////////////////////////////////


library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
----------------------------------------------------
entity ex_mem_reg is
port(
	Alu_result     :    in std_logic_vector (31 downto 0);
	Zero           :	  in std_logic;
	slt            :    in std_logic ;
	read_data2     :	  in std_logic_vector (31 downto 0);
	MUX_rd_OR_rt   :    in std_logic_vector(4 downto 0);
	
	memtoreg       :    in	std_logic;
	reg_write      :    in	std_logic;
	memwrite       :    in	std_logic;
	memread        :    in	std_logic;

	reset          :	  in std_logic;
	clk            :    in std_logic;
	
	Alu_result_out :    out std_logic_vector (31 downto 0);
	Zero_out       :	  out std_logic;
	slt_out        :    out std_logic;
	read_data2_out :	  out std_logic_vector (31 downto 0);
	MUX_rd_OR_rt_out :  out std_logic_vector(4 downto 0);
	
	pc_out         :    out std_logic_vector (31 downto 0);
	memtoreg_out   :    out	std_logic;
	reg_write_out  :    out	std_logic;
	memwrite_out   :    out	std_logic;
	memread_out    :    out	std_logic

	);
end ex_mem_reg;

architecture ex_mem_reg_arc of ex_mem_reg is	
begin
 process (clk,reset)
	begin

	if (reset= '1') then

		
		Alu_result_out <= (others => '0');
		Zero_out <= '0';
		read_data2_out <= (others => '0');
		MUX_rd_OR_rt_out <= (others => '0');
		


		memtoreg_out <= '0';
		reg_write_out<= '0';
		memwrite_out <= '0';
		memread_out <= '0';
		
		
   elsif rising_edge(clk) then
		
		
		Alu_result_out <= Alu_result;
		Zero_out <= Zero;
		read_data2_out <= read_data2;
		MUX_rd_OR_rt_out <= MUX_rd_OR_rt;
	
		memtoreg_out <= memtoreg;
		reg_write_out<= reg_write;
		memwrite_out <= memwrite;
		memread_out <= memread;
		
	end if;
	
	end process;
 
end ex_mem_reg_arc;