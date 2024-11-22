library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
		--50 MHz clock input
		clk : in  std_ulogic;

		-- push buttons and switches
		keys     : in std_ulogic_vector(3 downto 0);
		switches : in std_ulogic_vector(17 downto 0);

		--Seven segment displays
		hex0 : out std_ulogic_vector(6 downto 0) := (others=>'0');
		hex1 : out std_ulogic_vector(6 downto 0) := (others=>'0');
		hex2 : out std_ulogic_vector(6 downto 0) := (others=>'0');
		hex3 : out std_ulogic_vector(6 downto 0) := (others=>'0');
		hex4 : out std_ulogic_vector(6 downto 0) := (others=>'0');
		hex5 : out std_ulogic_vector(6 downto 0) := (others=>'0');
		hex6 : out std_ulogic_vector(6 downto 0) := (others=>'0');
		hex7 : out std_ulogic_vector(6 downto 0) := (others=>'0');

		-- the LEDs (green and red)
		ledg : out std_ulogic_vector(8 downto 0) := (others=>'0');
		ledr : out std_ulogic_vector(17 downto 0) := (others=>'0');

		-- GameCube controller
		gc_data : inout std_logic;
		
		-- SNES controller
		snes_latch : out std_logic := '0';
		snes_clk : out std_logic := '0';
		snes_data : in std_logic;

		--interface to SRAM
		sram_dq : inout std_logic_vector(15 downto 0);
		sram_addr : out std_logic_vector(19 downto 0) := (others=>'0');
		sram_ub_n : out std_logic := '0';
		sram_lb_n : out std_logic := '0';
		sram_we_n : out std_logic := '0';
		sram_ce_n : out std_logic := '0';
		sram_oe_n : out std_logic := '0';

		-- audio interface
		wm8731_xck     : out std_logic := '0';
		wm8731_sdat : inout std_logic;
		wm8731_sclk : inout std_logic;
		wm8731_dacdat  : out std_logic := '0';
		wm8731_daclrck : out std_logic := '0';
		wm8731_bclk    : out std_logic := '0';

		-- some auxiliary output for performing measurements
		aux : out std_logic_vector(15 downto 0) := (others=>'0');

		-- interface to ADV7123 and VGA connector
		vga_dac_r : out std_logic_vector(7 downto 0) := (others=>'0');
		vga_dac_g : out std_logic_vector(7 downto 0) := (others=>'0');
		vga_dac_b : out std_logic_vector(7 downto 0) := (others=>'0');
		vga_dac_clk : out std_logic := '0';
		vga_dac_sync_n : out std_logic := '0';
		vga_dac_blank_n : out std_logic := '0';
		vga_hsync : out std_logic := '0';
		vga_vsync : out std_logic := '0';
		
		-- interface to the character LCD (HD44780)
		char_lcd_data     : inout std_logic_vector(7 downto 0);
		char_lcd_en       : out std_logic := '0';
		char_lcd_rw       : out std_logic := '0';
		char_lcd_rs       : out std_logic := '0';
		char_lcd_on       : out std_logic := '0';
		char_lcd_blon     : out std_logic := '0';
		
		-- UART
		tx : out std_logic := '0';
		rx : in std_logic
	);
end entity;

