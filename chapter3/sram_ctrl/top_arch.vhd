library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util_pkg.all;
use work.sram_ctrl_pkg.all;
use work.test_sequence_pkg.all;

architecture top_arch of top is
	signal res_n : std_ulogic;
	signal rd, wr, busy, rd_valid : std_ulogic;
	signal addr : std_ulogic_vector(20 downto 0);
	signal wr_data, rd_data : std_ulogic_vector(15 downto 0);
	signal access_mode : sram_access_mode_t;
begin

	res_n <= keys(0);

	hex0 <= to_segs(rd_data(3 downto 0));
	hex1 <= to_segs(rd_data(7 downto 4));
	hex2 <= to_segs(rd_data(11 downto 8));
	hex3 <= to_segs(rd_data(15 downto 12));

	hex4 <= SSD_CHAR_OFF;
	hex5 <= SSD_CHAR_OFF;
	hex6 <= SSD_CHAR_OFF;
	hex7 <= SSD_CHAR_OFF;


	sram_ctrl_inst : entity work.sram_ctrl
	port map (
		clk   => clk,
		res_n => res_n,

		wr       => wr,
		rd       => rd,
		busy     => busy,
		rd_valid => rd_valid,

		addr        => addr,
		access_mode => access_mode,
		wr_data     => wr_data,
		rd_data     => rd_data,

		-- external interface to SRAM
		sram_dq   => sram_dq,
		sram_addr => sram_addr,
		sram_ub_n => sram_ub_n,
		sram_lb_n => sram_lb_n,
		sram_we_n => sram_we_n,
		sram_ce_n => sram_ce_n,
		sram_oe_n => sram_oe_n
	);


	sequence_fsm_inst : entity work.sequence_fsm
	port map (
		clk   => clk,
		res_n => res_n,

		wr       => wr,
		rd       => rd,
		busy     => busy,
		rd_valid => rd_valid,

		addr        => addr,
		access_mode => access_mode,
		wr_data     => wr_data,
		rd_data     => rd_data
	);

end architecture;

