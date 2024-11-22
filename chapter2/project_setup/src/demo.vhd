library ieee;
use ieee.std_logic_1164.all;

entity demo is
	port(
		a  : in  STD_LOGIC;
		b  : in  STD_LOGIC;
		x  : out STD_LOGIC
	);
end entity;

architecture arch of demo is
begin
	x <= a and b;
end architecture;
