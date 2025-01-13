library ieee;
use ieee.std_logic_1164.all;

use work.util_pkg.all;

architecture top_arch of top is
begin

	bcd_fsm_inst : entity work.bcd_fsm
		port map (
			clk           => clk,
			res_n         => keys(0),
			input_data    => switches(15 downto 0),
			signed_mode   => switches(17),
			hex_digit1    => hex0,
			hex_digit10   => hex1,
			hex_digit100  => hex2,
			hex_digit1000 => hex3,
			hex_sign      => hex4
		);

	hex5 <= SSD_CHAR_OFF;
	hex6 <= SSD_CHAR_OFF;
	hex7 <= SSD_CHAR_OFF;

end architecture;
