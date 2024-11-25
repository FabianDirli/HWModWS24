library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sorting_network_pkg.all;

entity sorting_network is
	generic (
		DATA_WIDTH : natural := 32
	);
	port (
		clk      : in std_logic;
		res_n    : in std_logic;

		unsorted_data : in  std_ulogic_vector;
		sorted_data   : out std_ulogic_vector;

		start : in std_ulogic;
		done  : out std_ulogic
	);
end entity;

architecture beh of sorting_network is

begin

end architecture;
