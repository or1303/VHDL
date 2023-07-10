library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity imem is
port ( pc:    in  std_logic_vector(31 downto 0);
       instr: out std_logic_vector(31 downto 0)
	  );
end entity imem;

architecture arc_imem of imem is
type mem_arr is array (natural range <>) of std_logic_vector(instr'range);
signal instruction_mem: mem_arr((2**8)-1 downto 0):= 
(0=>x"20010002",    -- addi $1=2
 1=>x"20020002",    -- addi $2=2
 2=>x"00222024",    -- $4 = $1 and $2
 3=>x"08000014",    -- jump to 21
 4=>x"08000015",
 5=>x"00000000",  
 6=>x"00000000",   
 7=>x"00000000", 
 8=>x"00000000", 
 9=>x"00000000", 
 10=>x"1022000a",  -- beq ofsset 10 if $1 = $2
 20=> x"ffffffff",
 21=> x"f0f0f0f0",
 31=> x"ffffffff",
 88=> x"ffffffff",
 others=>(others=>'0')
 );
begin
   
	instr<=instruction_mem(conv_integer(pc(9 downto 2)));
	
end architecture arc_imem;