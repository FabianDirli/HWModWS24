

library ieee;
use ieee.std_logic_1164.all;

use work.util_pkg.all;

entity util_tb is
end entity;

architecture bench of util_tb is
begin
	process
	begin
		assert to_segs(x"A") = SSD_CHAR_A report "" severity FAILURE;
		wait;
	end process;
end architecture;



