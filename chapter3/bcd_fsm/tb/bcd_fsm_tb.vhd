library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util_pkg.all;

entity bcd_fsm_tb is
end entity;

architecture tb of bcd_fsm_tb is
	signal clk, res_n : std_ulogic := '0';
	signal input_data : std_ulogic_vector(15 downto 0);
	signal signed_mode : std_ulogic;
	signal hex_digit1000, hex_digit100, hex_digit10, hex_digit1, hex_sign: std_ulogic_vector(6 downto 0);
begin

	dut : entity work.bcd_fsm
		port map (
			clk           => clk,
			res_n         => res_n,
			input_data    => input_data,
			signed_mode   => signed_mode,
			hex_digit1000 => hex_digit1000,
			hex_digit100  => hex_digit100,
			hex_digit10   => hex_digit10,
			hex_digit1    => hex_digit1,
			hex_sign      => hex_sign
		);

	clk_process : process
	begin
		-- TODO: Generate a clock signal
	end process;

	stimulus_process : process
	begin
			-- TODO: Implement the test cases
	end process;

end architecture;
