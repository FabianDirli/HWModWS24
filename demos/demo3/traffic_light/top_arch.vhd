library ieee;
use ieee.std_logic_1164.all;

use work.math_pkg.all;

architecture arch of top is
	constant WAIT_TIME : integer := 5;
	constant CLK_FREQ : integer := 50_000_000;
begin

	traffic_light_inst: entity work.traffic_light
	generic map (
		WAIT_TIME => WAIT_TIME,
		CLK_FREQ  => CLK_FREQ
	)
	port map (
		clk    => clk,
		res_n  => keys(0),
		clk_cnt_lb => aux(7 downto 0),
		-- pedestrian traffic light
		btn_n  => keys(3),
		pred   => ledg(0),
		pgreen => ledg(1),
		-- car traffic light
		cred   => ledr(0),
		cyell  => ledr(1),
		cgreen => ledr(2)
	);

end architecture;
