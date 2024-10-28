library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.alu_pkg.all;

entity alu is
	generic (
		DATA_WIDTH : positive := 32
	);
	port (
		op   : in  alu_op_t;
		a, b : in  std_ulogic_vector(DATA_WIDTH-1 downto 0);
		r    : out std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
		z    : out std_ulogic := '0'
	);
end entity;

-- put your architecture here
architecture alu_arch of alu is

begin

	alu_p : process (op, a, b) is
		variable x : integer := log2c(DATA_WIDTH) - 1;
  	begin
		case op is
			when ALU_NOP =>
				r <= b;
				z <= '-'; 
			when ALU_SLT =>
				if signed(a) < signed(b) then
					r <= std_ulogic_vector(to_signed(1, DATA_WIDTH));
					z <= '0';
				else
					r <= std_ulogic_vector(to_signed(0, DATA_WIDTH));
					z <= '1';
				end if;
			when ALU_SLTU =>
				if unsigned(a) < unsigned(b) then
					r <= std_ulogic_vector(to_signed(1, DATA_WIDTH));
					z <= '0';
				else
					r <= std_ulogic_vector(to_signed(0, DATA_WIDTH));
					z <= '1';
				end if;
			when ALU_SLL =>
				r <= std_ulogic_vector(shift_left(unsigned(a), to_integer(unsigned(b(x downto 0)))));
				z <= '-';
			when ALU_SRL =>
				r <= std_ulogic_vector(shift_right(unsigned(a), to_integer(unsigned(b(x downto 0)))));
				z <= '-';
			when ALU_SRA =>
				r <= std_ulogic_vector(signed(shift_right(signed(a), to_integer(signed(b(x downto 0))))));
				z <= '-';
			when ALU_ADD =>
				r <= std_logic_vector(signed(a) + signed(b));
				z <= '-';
			when ALU_SUB =>
				r <= std_logic_vector(signed(a) - signed(b));
				z <= '0' when (signed(a) - signed(b)) = 0 else '1';	--ANGABE???
			when ALU_AND =>
				r <= a and b;
				z <= '-';
			when ALU_OR =>
				r <= a or b;
				z <= '-';
			when ALU_XOR =>
				r <= a xor b;
				z <= '-';
		end case;
	end process;

end architecture;