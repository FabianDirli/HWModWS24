library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_signal_generator_tb is
end entity;

architecture tb of pwm_signal_generator_tb is
	constant COUNTER_WIDTH : integer := 8; -- Define the counter width
	signal clk, res_n, en : std_ulogic := '0';
	signal value : std_ulogic_vector(COUNTER_WIDTH-1 downto 0) := (others=>'0');
	signal pwm_out : std_ulogic;
begin

	dut : entity work.pwm_signal_generator
		generic map (
			COUNTER_WIDTH => COUNTER_WIDTH
		)
		port map (
			clk     => clk,
			res_n   => res_n,
			en      => en,
			value   => value,
			pwm_out => pwm_out
		);

	clk_process : process
	begin
		-- TODO: Generate a 1 MHz clock signal
	end process;

	stimulus_process : process
		procedure check_pwm_signal(low_time, high_time: time) is
		begin
			-- TODO: Implement this procedure
		end procedure;
	begin
			-- TODO: Implement the test cases
	end process;

end architecture;
