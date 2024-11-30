library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;

entity timer is
	generic (
		CLK_PERIOD : time;
		DIGITS     : integer
	);
	port (
		clk         : in std_ulogic;
		res_n       : in std_ulogic;
		start_n     : in std_ulogic;
		stop_n      : in std_ulogic;
		seconds_in  : in unsigned(log2c(10**DIGITS)-1 downto 0);
		seconds_out : out unsigned(log2c(10**DIGITS)-1 downto 0)
	);
end entity;

architecture arch of timer is
begin


end architecture;
