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

	clk_gen : process is
	begin
	end process;

end architecture;

