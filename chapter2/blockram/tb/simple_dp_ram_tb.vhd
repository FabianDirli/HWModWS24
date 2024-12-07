library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity simple_dp_ram_tb is
end entity;

architecture tb of simple_dp_ram_tb is
	constant CLK_PERIOD : time := 20 ns;  -- Clock period
	signal clk, res_n : std_ulogic;

begin
	-- instantiate uut

	-- Clock generation process

	-- Stimulus process to handle file I/O and write to RAM
	stimulus : process
	begin
		res_n <= '0';
		wait for 10 ns;
		-- End simulation
		std.env.stop;
	end process;

end architecture;
