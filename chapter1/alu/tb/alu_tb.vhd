library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.math_pkg.all;
use work.alu_pkg.all;

entity alu_tb is
end entity;

architecture tb of alu_tb is
	signal op : alu_op_t;
  	signal a, b, r : std_ulogic_vector(31 downto 0);
	signal z : std_logic; 
begin

	-- Instantiate your ALU here

	uut : entity work.alu
	port map (
		op => op,
		a => a,
		b => b,
		r => r,
		z => z
	);

	stimuli : process
	begin
		-- apply your stimulus here

		report "asdlkjs  " & to_string(to_integer(shift_left(to_signed(-2, 32), 2)));

		a <= std_logic_vector(to_signed(32, 32));
		b <= std_logic_vector(to_signed(2, 32));

		--test ALU_NOP
		op <= ALU_NOP;
		wait for 1 ns;

		--test ALU_SLT
		op <= ALU_SLT;
		wait for 1 ns;
		a <= std_logic_vector(to_signed(-50, 32));
		b <= std_logic_vector(to_signed(20, 32));
		wait for 1 ns;

		--test ALU_SLTU
		op <= ALU_SLTU;
		a <= std_logic_vector(to_signed(32, 32));
		b <= std_logic_vector(to_signed(2, 32));
		wait for 1 ns;

		--test ALU_SLL
		op <= ALU_SLL;
		wait for 1 ns;

		--test ALU_SRL
		op <= ALU_SRL;
		wait for 1 ns;

		--test ALU_SRA
		op <= ALU_SRA;
		a <= std_logic_vector(to_signed(-32, 32));
		b <= std_logic_vector(to_signed(2, 32));
		wait for 1 ns;

		-- test ALU_ADD
		op <= ALU_ADD;
		wait for 1 ns;
		a <= std_logic_vector(to_signed(32, 32));
		b <= std_logic_vector(to_signed(8, 32));
		wait for 1 ns;

		--test ALU_SUB
		op <= ALU_SUB;
		wait for 1 ns;
		a <= std_logic_vector(to_signed(32, 32));
		b <= std_logic_vector(to_signed(32, 32));
		wait for 1 ns;

		--test ALU_AND
		op <= ALU_AND;
		a <= std_logic_vector(to_signed(32, 32));
		b <= std_logic_vector(to_signed(1, 32));
		wait for 1 ns;

		--test ALU_OR
		op <= ALU_OR;
		wait for 1 ns;

		--test ALU_XOR
		op <= ALU_XOR;
		wait for 1 ns;

		wait;
	end process;
end architecture;