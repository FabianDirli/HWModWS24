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
	Signal C : std_ulogic_vector (N/4 downto 0);
begin

	C(0) <= '0';
	
	adderN_gen : for i in 1 to N / 4 generate
		
		add : entity work.adder4
		port map (
			A => A(4*i-1 downto 4*(i-1)),
			B => B(4*i-1 downto 4*(i-1)),
			S => S(4*i-1 downto 4*(i-1)),
			Cin => C(i-1),
			Cout => C(i)
		);

	end generate;

	Cout <= C(N/4);

end architecture;
