library ieee;
use ieee.std_logic_1164.all;

package sorting_network_pkg is
	component sorting_network is
		generic (
			DATA_WIDTH : natural := 32
		);
		port (
			clk      : in std_ulogic;
			res_n    : in std_ulogic;
			
			unsorted_data : in  std_ulogic_vector;
			sorted_data   : out std_ulogic_vector;

			start : in std_ulogic;
			done  : out std_ulogic
		);
	end component;
end package;

