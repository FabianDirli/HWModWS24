library ieee;
use ieee.std_logic_1164.all;

entity generic_adder is
	generic (
		N : positive := 4
	);
	port (
		A    : in std_ulogic_vector(N-1 downto 0);
		B    : in std_ulogic_vector(N-1 downto 0);

		S    : out std_ulogic_vector(N-1 downto 0);
		Cout : out std_ulogic
	);
end entity;



architecture beh of generic_adder is
begin
end architecture;
