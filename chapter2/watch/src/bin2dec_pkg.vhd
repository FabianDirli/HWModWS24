library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package bin2dec_pkg is
	-- decimal digit [0,9]
	subtype dec_digit_t is unsigned(3 downto 0);
	type dec_digits_t is array(integer range <>) of dec_digit_t;

	component bin2dec is
		generic(
			SSD_DIGITS : integer
		);
		port(
			clk     : in std_ulogic;
			res_n   : in std_ulogic;
			binary  : in unsigned;
			decimal : out dec_digits_t
		);
	end component;
end package;
