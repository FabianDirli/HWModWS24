library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.bin2dec_pkg.all;

entity bin2dec is
	generic(
		SSD_DIGITS : integer
	);
	port(
		clk     : in std_ulogic;
		res_n   : in std_ulogic;
		binary  : in unsigned(log2c(10**SSD_DIGITS)-1 downto 0);
		decimal : out dec_digits_t(SSD_DIGITS-1 downto 0)
	);
end entity;

architecture arch of bin2dec is
begin


end architecture;
