library ieee;
use ieee.std_logic_1164.all;

architecture top_arch of top is
	signal pwm_out : std_ulogic;
begin

	pwm_signal_generator_inst : entity work.pwm_signal_generator
		generic map (
			COUNTER_WIDTH => 8
		)
		port map (
			clk     => clk,
			res_n   => keys(0),
			en      => switches(17),
			value   => switches(7 downto 0),
			pwm_out => pwm_out
		);

	ledg(0) <= pwm_out;

	-- top-right GPIO pin (GPIO[1] in datasheet/task description)
	aux(0) <= pwm_out;

end architecture;
