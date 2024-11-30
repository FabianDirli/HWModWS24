library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.util_pkg.all;
use work.bin2dec_pkg.all;

architecture top_arch of top is
	constant CLK_PERIOD : time := 20 ns; -- make sure this is set according to the clock you use!
	constant SSD_DIGITS : integer := 4;
	signal clk_20 : std_ulogic;  -- 20 MHz clock
	signal res_n  : std_ulogic;
	signal dec_digits : dec_digits_t(7 downto 0) := (others => (others => '0'));

	component pll_20MHz is
		port (
			inclk0 : in std_logic := '0';
			c0     : out std_logic
		);
	end component;
begin

	res_n <= keys(0);

	pll_inst : pll_20MHz
	port map(
		inclk0 => clk,
		c0     => clk_20
	);


	hex0 <= to_segs(std_ulogic_vector(dec_digits(0)));
	hex1 <= to_segs(std_ulogic_vector(dec_digits(1)));
	hex2 <= to_segs(std_ulogic_vector(dec_digits(2)));
	hex3 <= to_segs(std_ulogic_vector(dec_digits(3)));

	hex4 <= to_segs(std_ulogic_vector(dec_digits(4)));
	hex5 <= to_segs(std_ulogic_vector(dec_digits(5)));
	hex6 <= to_segs(std_ulogic_vector(dec_digits(6)));
	hex7 <= to_segs(std_ulogic_vector(dec_digits(7)));

end architecture;
