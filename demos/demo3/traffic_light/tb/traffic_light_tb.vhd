library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;

entity traffic_light_tb is
end entity;

architecture tb of traffic_light_tb is
	constant WAIT_TIME : integer := 4;
	constant CLK_FREQ : integer := 10;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;
	signal stop_clk : boolean := false;
	signal clk, res_n, pgreen, pred, cgreen, cred, cyell, btn_n : std_ulogic;
begin

	stim : process begin
		res_n <= '0';
		btn_n <= '1';
		wait until rising_edge(clk);
		wait for CLK_PERIOD;
		res_n <= '1';
		wait for 10*CLK_PERIOD;

		btn_n <= '0';
		wait for CLK_PERIOD;
		btn_n <= '1';
		wait for CLK_PERIOD;

		wait until pgreen = '1';
		wait until pred = '1' and cgreen = '1';
		wait for 20*CLK_PERIOD;

		report "Testbench done";
		stop_clk <= true;
		wait;
	end process;

	clk_gen : process begin
		while not stop_clk loop
			clk <= '0';
			wait for CLK_PERIOD / 2;
			clk <= '1';
			wait for CLK_PERIOD / 2;
		end loop;
		wait;
	end process;

	dut : entity work.traffic_light
	generic map (
		WAIT_TIME => WAIT_TIME,
		CLK_FREQ  => CLK_FREQ
	)
	port map (
		clk        => clk,
		res_n      => res_n,
		clk_cnt_lb => open,
		btn_n      => btn_n,
		pred       => pred,
		pgreen     => pgreen,
		cred       => cred,
		cyell      => cyell,
		cgreen     => cgreen
	);

end architecture;
