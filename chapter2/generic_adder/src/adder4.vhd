library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder4 is
	port (
		A : in std_ulogic_vector(3 downto 0);
		B : in std_ulogic_vector(3 downto 0);
		Cin : in std_ulogic;

		S  : out std_ulogic_vector(3 downto 0);
		Cout  : out std_ulogic
	);
end entity;

architecture beh of adder4 is
	signal adder_cout : std_ulogic_vector(3 downto 0) := "0000";
begin
	process(all)
		variable temp: std_ulogic_vector(4 downto 0);
		variable cinv: std_ulogic_vector(3 downto 0);
	begin
		cinv := "000" & cin;
		temp := std_ulogic_vector(unsigned('0' & a) + unsigned('0' & b) + unsigned(cinv));
		S <= temp(3 downto 0);
		cout <= temp(4);
	end process;
end architecture;


