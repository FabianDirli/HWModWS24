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
	signal clk_stop : boolean := false;
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
		while not clk_stop loop
			clk <= '0';
			wait for 500 ns;
			clk <= '1';
			wait for 500 ns;
		end loop;
		wait;
	end process;

	stimulus_process : process
		procedure check_pwm_signal(low_time, high_time: time) is
			variable previous : time;
		begin
			-- TODO: Implement this procedure
			en <= '1';
			previous := now;
			wait until rising_edge(pwm_out);
			--assert low_time = now - previous report "Low time WRONG! Should be " & low_time & " and got " & (now - previous);
			report time'image(now);
			en <= '0';
			previous := now;
			wait until falling_edge(pwm_out);
			assert high_time = now - previous report "High time WRONG!";
		end procedure;

		
	begin
			-- TODO: Implement the test cases
		for i in 1 to (2**COUNTER_WIDTH)-1 loop
			res_n <= '0';
			wait for 1 us;
			res_n <= '1';
			value <= std_logic_vector(to_unsigned(i, COUNTER_WIDTH));
			check_pwm_signal(1 us * (i - 1), 1 us * (2**COUNTER_WIDTH - i));

		end loop;
		clk_stop <= true;
		wait;
	end process;

end architecture;
