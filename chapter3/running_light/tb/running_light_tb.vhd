library ieee;
use ieee.std_logic_1164.all;

entity running_light_tb is
end entity;

architecture arch of running_light_tb is
	constant LEDS_WIDTH : integer := 8;
	constant CLK_PERIOD : time := 20 ns;
	signal stop_clk : boolean := false;
	signal clk, res_n : std_ulogic;
	signal leds : std_ulogic_vector(LEDS_WIDTH-1 downto 0);
begin


	uut : entity work.running_light
	generic map (
		STEP_TIME => 100 ns
	)
	port map (
		clk => clk,
		res_n => res_n,
		leds => leds
	);

	stimulus : process is
	begin
		res_n <= '0';
		wait for 2*CLK_PERIOD;
		res_n <= '1';
		wait for CLK_PERIOD;
		wait for 1000 ns;
		stop_clk <= true;
		wait;
	end process;

	clk_gen : process is
	begin
		while not stop_clk loop
			clk <= '0';
			wait for CLK_PERIOD/2;
			clk <= '1';
			wait for CLK_PERIOD/2;
		end loop;
		wait;
	end process;

end architecture;

