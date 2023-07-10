--///////////////////////////////////////////////////////////////////////////
--// MODULE               : Execute                                  //
--//                                                                       //
--// DESIGNER             : Or_Meir_Sofer && Nitzan_Elimelech              //
--//								                                          	   //                 
--// VHDL code for execute phase                                                     //
--//                                                  			            //
--// 				                                            					   //
--///////////////////////////////////////////////////////////////////////////


library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity Execute is

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
		end Execute;
		
		
architecture Execute_arc of Execute is


component ex_mem_reg is
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
end component ex_mem_reg;



	signal Mux_ALuSrc_out: std_logic_vector(31 downto 0);
	signal Mux_rd_OR_rt_out: std_logic_vector(4 downto 0);
	signal alu_result_sig : std_logic_vector (31 downto 0); 
	signal alu_zero_out_sig : std_logic;
	signal Mux_rd_OR_rt_out_sig : std_logic_vector (4 downto 0);
	signal alu_set_less_than_bit : std_logic;
   signal alu_set_less_than_sig : std_logic_vector (31 downto 0);
	
	signal alu_mux_1 : std_logic_vector (31 downto 0);
	signal alu_mux_2 : std_logic_vector (31 downto 0);
	
	begin

	
	ex_mem : ex_mem_reg
	port map(
	reset => reset,
	clk => clk,
	Alu_result => alu_result_sig,
	Zero=> alu_zero_out_sig,
	slt => alu_set_less_than_bit,
	read_data2=> read_data_2_in,
	MUX_rd_OR_rt => Mux_rd_OR_rt_out_sig,
	memtoreg=> memtoreg,
	reg_write=> reg_write,
	memwrite=> memwrite,
	memread => memread,
	Alu_result_out => alu_result,
	Zero_out => alu_zero_out,
	slt_out => alu_set_less_than,
	read_data2_out => read_data_2_out,
	MUX_rd_OR_rt_out => register_to_write,
	memtoreg_out => memtoreg_out,
	reg_write_out => reg_write_out,
	memwrite_out=> memwrite_out,
	memread_out => memread_out
	);
	
	
	alu_mux_1 <= read_data_1 when forward_mux_1 = "00" else
					 mem_forward when forward_mux_1 = "01" else
					 writeback_forward when forward_mux_1 = "10" else (others => '0');
	
  	alu_mux_2 <= read_data_2_in when forward_mux_2 = "00" else
					 mem_forward when forward_mux_2 = "01" else
					 writeback_forward when forward_mux_2 = "10" else (others => '0');
					 
	----------------MUX AluSrc part----------------------------------------
	Mux_ALuSrc_out <=     alu_mux_2  when (alu_src = '0') else
			      sign_extended_in when (alu_src = '1') else (others => '0');
	-----------------------------------------------------------------------
	----------------MUX rd_OR_rt part------------------------------------
	Mux_rd_OR_rt_out_sig <= rt_reg when (reg_dst = '0') else
			        rd_reg when (reg_dst = '1') else (others => '0');
	---------------------------------------------------------------------
	----------------Alu part--------------------------------------------------------------------------------------------------------------------
	
	alu_result_sig <= (alu_mux_1 + Mux_ALuSrc_out)   when (alu_op="00") else-- ADD -->for lw instructions
		          (alu_mux_1 - Mux_ALuSrc_out)   when (alu_op="01") else-- SUB -->for beq instructions
		          (alu_mux_1 + Mux_ALuSrc_out)   when ((function_in ="100000") and (alu_op="10")) else-- ADD -->for addu instructions
			  (alu_mux_1 - Mux_ALuSrc_out)   when ((function_in ="100010") and (alu_op="10")) else-- SUB -->for sub instructions
		          (alu_mux_1 and Mux_ALuSrc_out) when ((function_in ="100100") and (alu_op="10")) else-- AND -->for and instructions
		          (alu_mux_1 or Mux_ALuSrc_out)  when ((function_in ="100101") and (alu_op="10")) else-- OR -->for or instructions
                          (alu_set_less_than_sig)        when ((function_in ="101010") and (alu_op="10")) else -- SLT
			  (others=>'0');
	
	alu_zero_out_sig <= '1' when (alu_mux_1 = Mux_ALuSrc_out) else '0';
	alu_set_less_than_bit <= '1' when (alu_mux_1 < Mux_ALuSrc_out) else '0';
	alu_set_less_than_sig <= "0000000000000000000000000000000" & alu_set_less_than_bit;
	
	

							
end  Execute_arc;