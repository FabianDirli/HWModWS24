library ieee;
use ieee.std_logic_1164.all;

entity dbg_top is
	port (
		clk : in std_ulogic;
		keys : in std_ulogic_vector(3 downto 0);
		switches : in std_ulogic_vector(17 downto 0);
		hex0 : buffer std_ulogic_vector(6 downto 0);
		hex1 : buffer std_ulogic_vector(6 downto 0);
		hex2 : buffer std_ulogic_vector(6 downto 0);
		hex3 : buffer std_ulogic_vector(6 downto 0);
		hex4 : buffer std_ulogic_vector(6 downto 0);
		hex5 : buffer std_ulogic_vector(6 downto 0);
		hex6 : buffer std_ulogic_vector(6 downto 0);
		hex7 : buffer std_ulogic_vector(6 downto 0);
		ledg : buffer std_ulogic_vector(8 downto 0);
		ledr : buffer std_ulogic_vector(17 downto 0);
		gc_data : inout std_logic;
		snes_latch : buffer std_logic;
		snes_clk : buffer std_logic;
		snes_data : in std_logic;
		sram_dq : inout std_logic_vector(15 downto 0);
		sram_addr : buffer std_logic_vector(19 downto 0);
		sram_ub_n : buffer std_logic;
		sram_lb_n : buffer std_logic;
		sram_we_n : buffer std_logic;
		sram_ce_n : buffer std_logic;
		sram_oe_n : buffer std_logic;
		wm8731_xck : buffer std_logic;
		wm8731_sdat : inout std_logic;
		wm8731_sclk : inout std_logic;
		wm8731_dacdat : buffer std_logic;
		wm8731_daclrck : buffer std_logic;
		wm8731_bclk : buffer std_logic;
		aux : buffer std_logic_vector(15 downto 0);
		vga_dac_r : buffer std_logic_vector(7 downto 0);
		vga_dac_g : buffer std_logic_vector(7 downto 0);
		vga_dac_b : buffer std_logic_vector(7 downto 0);
		vga_dac_clk : buffer std_logic;
		vga_dac_sync_n : buffer std_logic;
		vga_dac_blank_n : buffer std_logic;
		vga_hsync : buffer std_logic;
		vga_vsync : buffer std_logic;
		char_lcd_data : inout std_logic_vector(7 downto 0);
		char_lcd_en : buffer std_logic;
		char_lcd_rw : buffer std_logic;
		char_lcd_rs : buffer std_logic;
		char_lcd_on : buffer std_logic;
		char_lcd_blon : buffer std_logic;
		tx : buffer std_logic;
		rx : in std_logic;
		emulated_snes_clk : in std_logic;
		emulated_snes_latch : in std_logic;
		emulated_snes_data : out std_logic;
		emulated_gc_data : inout std_logic
	);
end entity;


architecture dbg_top_arch of dbg_top is
	signal keys_intercepted : std_logic_vector(3 downto 0);
	signal switches_intercepted : std_logic_vector(17 downto 0);
	signal emulated_rx : std_logic;
	signal emulated_tx : std_logic;

	signal hex_segments_input : std_ulogic_vector(63 downto 0);

	component dbg_core is
		port (
			clk : in std_logic;
			tx : out std_logic;
			rx : in std_logic;
			emulated_snes_clk : in std_logic;
			emulated_snes_latch : in std_logic;
			emulated_snes_data : out std_logic;
			emulated_gc_data : inout std_logic;
			emulated_rx : in std_logic;
			emulated_tx : out std_logic;
			hex_segments_input : in std_logic_vector(8 * 8 - 1 downto 0);
			ledr_input : in std_logic_vector(1 * 18 - 1 downto 0);
			ledg_input : in std_logic_vector(1 * 9 - 1 downto 0);
			switches_input : in std_logic_vector(18 - 1 downto 0);
			switches_output : out std_logic_vector(18 - 1 downto 0);
			keys_input : in std_logic_vector(4 - 1 downto 0);
			keys_output : out std_logic_vector(4 - 1 downto 0)
		);
	end component;

	component top is
		port (
			clk : in std_ulogic;
			keys : in std_ulogic_vector(3 downto 0);
			switches : in std_ulogic_vector(17 downto 0);
			hex0 : out std_ulogic_vector(6 downto 0);
			hex1 : out std_ulogic_vector(6 downto 0);
			hex2 : out std_ulogic_vector(6 downto 0);
			hex3 : out std_ulogic_vector(6 downto 0);
			hex4 : out std_ulogic_vector(6 downto 0);
			hex5 : out std_ulogic_vector(6 downto 0);
			hex6 : out std_ulogic_vector(6 downto 0);
			hex7 : out std_ulogic_vector(6 downto 0);
			ledg : out std_ulogic_vector(8 downto 0);
			ledr : out std_ulogic_vector(17 downto 0);
			gc_data : inout std_logic;
			snes_latch : out std_logic;
			snes_clk : out std_logic;
			snes_data : in std_logic;
			sram_dq : inout std_logic_vector(15 downto 0);
			sram_addr : out std_logic_vector(19 downto 0);
			sram_ub_n : out std_logic;
			sram_lb_n : out std_logic;
			sram_we_n : out std_logic;
			sram_ce_n : out std_logic;
			sram_oe_n : out std_logic;
			wm8731_xck : out std_logic;
			wm8731_sdat : inout std_logic;
			wm8731_sclk : inout std_logic;
			wm8731_dacdat : out std_logic;
			wm8731_daclrck : out std_logic;
			wm8731_bclk : out std_logic;
			aux : out std_logic_vector(15 downto 0);
			vga_dac_r : out std_logic_vector(7 downto 0);
			vga_dac_g : out std_logic_vector(7 downto 0);
			vga_dac_b : out std_logic_vector(7 downto 0);
			vga_dac_clk : out std_logic;
			vga_dac_sync_n : out std_logic;
			vga_dac_blank_n : out std_logic;
			vga_hsync : out std_logic;
			vga_vsync : out std_logic;
			char_lcd_data : inout std_logic_vector(7 downto 0);
			char_lcd_en : out std_logic;
			char_lcd_rw : out std_logic;
			char_lcd_rs : out std_logic;
			char_lcd_on : out std_logic;
			char_lcd_blon : out std_logic;
			tx : out std_logic;
			rx : in std_logic
		);
	end component;

begin

	top_inst: top
	port map (
		clk => clk,
		keys => std_ulogic_vector(keys_intercepted),
		switches => std_ulogic_vector(switches_intercepted),
		hex0 => hex0,
		hex1 => hex1,
		hex2 => hex2,
		hex3 => hex3,
		hex4 => hex4,
		hex5 => hex5,
		hex6 => hex6,
		hex7 => hex7,
		ledg => ledg,
		ledr => ledr,
		gc_data => gc_data,
		snes_latch => snes_latch,
		snes_clk => snes_clk,
		snes_data => snes_data,
		sram_dq => sram_dq,
		sram_addr => sram_addr,
		sram_ub_n => sram_ub_n,
		sram_lb_n => sram_lb_n,
		sram_we_n => sram_we_n,
		sram_ce_n => sram_ce_n,
		sram_oe_n => sram_oe_n,
		wm8731_xck => wm8731_xck,
		wm8731_sdat => wm8731_sdat,
		wm8731_sclk => wm8731_sclk,
		wm8731_dacdat => wm8731_dacdat,
		wm8731_daclrck => wm8731_daclrck,
		wm8731_bclk => wm8731_bclk,
		aux => aux,
		vga_dac_r => vga_dac_r,
		vga_dac_g => vga_dac_g,
		vga_dac_b => vga_dac_b,
		vga_dac_clk => vga_dac_clk,
		vga_dac_sync_n => vga_dac_sync_n,
		vga_dac_blank_n => vga_dac_blank_n,
		vga_hsync => vga_hsync,
		vga_vsync => vga_vsync,
		char_lcd_data => char_lcd_data,
		char_lcd_en => char_lcd_en,
		char_lcd_rw => char_lcd_rw,
		char_lcd_rs => char_lcd_rs,
		char_lcd_on => char_lcd_on,
		char_lcd_blon => char_lcd_blon,
		tx => emulated_rx,
		rx => emulated_tx
	);

	hex_segments_input <= '0' & hex7 & '0' & hex6 & '0' & hex5 & '0' & hex4 & '0' & hex3 & '0' & hex2 & '0' & hex1 & '0' & hex0;

	dbg_core_inst : dbg_core
	port map (
		clk => clk,
		tx => tx,
		rx => rx,
		emulated_snes_clk => emulated_snes_clk,
		emulated_snes_latch => emulated_snes_latch,
		emulated_snes_data => emulated_snes_data,
		emulated_gc_data => emulated_gc_data,
		emulated_rx => emulated_rx,
		emulated_tx => emulated_tx,
		hex_segments_input => std_logic_vector(hex_segments_input),
		ledr_input => std_logic_vector(ledr),
		ledg_input => std_logic_vector(ledg),
		switches_input => std_logic_vector(switches),
		switches_output => switches_intercepted,
		keys_input => std_logic_vector(keys),
		keys_output => keys_intercepted
	);

end architecture;
