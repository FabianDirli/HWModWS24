library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;

entity running_light is
	generic (
		STEP_TIME  : time := 1 sec
	);
	port (
		clk      : in std_logic;
		res_n    : in std_logic;
		leds     : out std_logic_vector
	);
end entity;

architecture arch of running_light is
begin

end architecture;

