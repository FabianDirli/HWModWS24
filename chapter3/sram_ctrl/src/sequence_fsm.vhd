library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sram_ctrl_pkg.all;
use work.test_sequence_pkg.all;

entity sequence_fsm is
	port (
		clk   : in  std_ulogic;
		res_n : in std_ulogic;

		rd       : out std_ulogic;
		wr       : out std_ulogic;
		busy     : in std_ulogic;
		rd_valid : in std_ulogic;

		addr        : out byte_addr_t;
		access_mode : out sram_access_mode_t;
		wr_data     : out uword_t;
		rd_data     : in uword_t
	);
end entity;

architecture beh of sequence_fsm is
	-- TODO: Add required types and signals
begin

	sync : process(clk, res_n) begin
		-- TODO: Implement the state register
	end process;

	comb : process(all) is
	begin
		-- TODO: Implement the output and next-state logic
	end process;

end architecture;
