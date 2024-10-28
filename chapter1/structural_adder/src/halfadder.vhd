library ieee;
use ieee.std_logic_1164.all;
use work.adder4_pkg.all;

entity halfadder is
	port (
		A : in std_ulogic;
		B : in std_ulogic;

		Sum  : out std_ulogic;
		Cout : out std_ulogic
	);
end entity;

architecture halfadder_arch of halfadder is 
begin
	xor_gate : entity work.xor_gate
	port map (
		A => A,
		B => B,
		Z => Sum
	);

	and_gate : entity work.and_gate
	port map (
		A => A,
		B => B,
		Z => Cout
	);
end architecture;