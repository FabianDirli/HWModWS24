library ieee;
use ieee.std_logic_1164.all;

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

end architecture;
