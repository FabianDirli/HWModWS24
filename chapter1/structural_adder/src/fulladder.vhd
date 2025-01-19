library ieee;
use ieee.std_logic_1164.all;
use work.adder4_pkg.all;

entity fulladder is
	port (
		A    : in std_ulogic;
		B    : in std_ulogic;
		Cin  : in std_ulogic;

		Sum  : out std_ulogic;
		Cout : out std_ulogic
	);
end entity;

architecture fulladder_arch of fulladder is
	signal x, y, z: std_ulogic;
begin
	ha1 : entity work.halfadder
	port map (
		A => A,
		B => B,
		Sum => x,
		Cout => y
	);

	ha2 : entity work.halfadder
	port map (
		A => Cin,
		B => x,
		Sum => Sum,
		Cout => z
	);

	or_gate : entity work.or_gate
	port map (
		A => z,
		B => y,
		Z => Cout
	);

end architecture;