library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.math_pkg.all;
use work.bin2dec_pkg.all;

entity bin2dec_tb is
end entity;

architecture tb of bin2dec_tb is
	signal bin_in   :  std_ulogic_vector (7 downto 0);
	signal dec_out  :  integer;
	signal bcd_out  :  std_ulogic_vector (11 downto 0);
begin

	uut : entity work.bin2dec
	port map(
		bin_in => bin_in,
		dec_out => dec_out,
		bcd_out => bcd_out
	);

	stimuli : process
	begin

		report "Test binary: (11011011)";
		bin_in <= (7 downto 0 => "11011011", others => '0');
		wait for 10 ns;
		report to_string(bin_in) & " is decimal:" & to_string(dec_out) & " is BCD " & to_string(bcd_out);
		assert dec_out = 219 report "Decimal: " & to_string(dec_out) & " for binary: " & to_string(bin_in) & " is wrong!" severity error;
		assert bcd_out = "001000011001" report "BCD: " & to_string(bcd_out) & " for binary: " & to_string(bin_in) & " is wrong!" severity error;

		wait;
	end process;
end architecture;

