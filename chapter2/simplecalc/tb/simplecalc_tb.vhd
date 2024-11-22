library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity simplecalc_tb is
end entity;

architecture bench of simplecalc_tb is

begin

	-- Instantiate the unit under test

	-- Stimulus process
	stimulus: process
	begin
		report "simulation start";

		-- Apply test stimuli


		wait for 10 ns;
		assert 1 = 0 report "Test x failed" severity error;

		report "simulation end";
		-- End simulation
		wait;
	end process;
end architecture;

