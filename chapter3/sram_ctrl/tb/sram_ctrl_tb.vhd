library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sram_ctrl_pkg.all;
use work.sram_pkg.all;
use work.test_sequence_pkg.all;

entity sram_ctrl_tb is
end entity;

architecture tb of sram_ctrl_tb is
	signal CLK_PERIOD : time := 20 ns;
	signal stop_clk : boolean := false;
	signal clk, res_n : std_ulogic;
	signal rd, wr, busy, rd_valid : std_ulogic := '0';
	signal addr : byte_addr_t;
	signal wr_data, rd_data : std_ulogic_vector(15 downto 0);
	signal access_mode : sram_access_mode_t;

	signal sram_dq : std_logic_vector(15 downto 0) := (others => 'Z');
	signal sram_addr : word_addr_t;
	signal sram_ub_n : std_logic;
	signal sram_lb_n : std_logic;
	signal sram_we_n : std_logic;
	signal sram_ce_n : std_logic;
	signal sram_oe_n : std_logic;
begin

	stimulus : process is
	begin
		-- TODO: reset your design and apply stimuli as needed
	end process;

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

	sram_inst : entity work.sram
	port map (
		A    => sram_addr,
		IO   => sram_dq,
		CE_N => sram_ce_n,
		OE_N => sram_oe_n,
		WE_N => sram_we_n,
		LB_N => sram_lb_n,
		UB_N => sram_ub_n
	);

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

	clk_gen : process is
	begin
	end process;

end architecture;

