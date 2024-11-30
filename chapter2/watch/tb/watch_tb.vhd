library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity watch_tb is
end entity;

architecture tb of watch_tb is
	constant CLK_PERIOD : time := 20 ns;  -- Change as required
	signal clk, res_n : std_ulogic;
begin

	stimulus : process begin
		-- Add stimuli
		wait;
	end process;

	clk_gen : process begin
		-- generate clock
		wait;
	end process;

end architecture;
