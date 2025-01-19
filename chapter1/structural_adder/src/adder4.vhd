library ieee;
use ieee.std_logic_1164.all;
use work.adder4_pkg.all;

entity adder4 is
	port (
		A    : in std_ulogic_vector(3 downto 0);
		B    : in std_ulogic_vector(3 downto 0);
		Cin  : in std_ulogic;

		S    : out std_ulogic_vector(3 downto 0);
		Cout : out std_ulogic
	);
end entity;

architecture adder4_arch of adder4 is
	signal c01, c12, c23 : std_ulogic;
begin
	fa0 : entity work.fulladder
	port map (
		A => A(0),
		B => B(0),
		Cin => Cin,
		Sum => S(0),
		Cout => c01
	);
	fa1 : entity work.fulladder
	port map (
		A => A(1),
		B => B(1),
		Cin => c01,
		Sum => S(1),
		Cout => c12
	);
	fa2 : entity work.fulladder
	port map (
		A => A(2),
		B => B(2),
		Cin => c12,
		Sum => S(2),
		Cout => c23
	);
	fa3 : entity work.fulladder
	port map (
		A => A(3),
		B => B(3),
		Cin => c23,
		Sum => S(3),
		Cout => Cout
	);
end architecture;
