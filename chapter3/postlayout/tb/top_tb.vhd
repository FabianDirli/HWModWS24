library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end entity;

architecture tb of top_tb is
	constant CLK_PERIOD : time := 20 ns;
	signal stop_clock : boolean := false;
	signal clk, res_n : std_ulogic := '0';
	signal aux : std_ulogic_vector(15 downto 0);
begin

	uut : entity work.top
	port map (
		clk       => clk,
		keys      => (0 => res_n, others => '0'),
		switches  => (0 => '1', others => '0'),
		aux       => aux,
		snes_data => '0',
		rx        => '0'
	);

	clk_process : process
	begin
		while not stop_clock loop
			clk <= '0';
			wait for CLK_PERIOD / 2;
			clk <= '1';
			wait for CLK_PERIOD / 2;
		end loop;
		wait;
	end process;

	measure_max_skew : process
	begin
		res_n <= '0';
		wait for 10*CLK_PERIOD;
		res_n <= '1';

		-- TODO: Implement the skew measurement here

		wait for 10*CLK_PERIOD;
		stop_clock <= true;
		report "simulation done";
		wait;
	end process;

end architecture;
