library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
	generic (
		WIDTH : positive := 8
	);
	port (
		clk : in std_logic;
		res_n : in std_logic;
		en_n : in std_logic;
		x : out std_ulogic_vector(WIDTH-1 downto 0)
	);
end entity;

architecture arch of counter is
begin
end architecture;


