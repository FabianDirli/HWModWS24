library ieee;
use ieee.std_logic_1164.all;

architecture top_arch of top is
begin

	led_controller : entity work.running_light
	generic map(
		STEP_TIME => 1 sec
	)
	port map (
		clk => clk,
		res_n => keys(0),
		leds => ledr(17 downto 0)
	);
end architecture;

