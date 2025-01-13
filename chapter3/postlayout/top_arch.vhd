library ieee;
use ieee.std_logic_1164.all;

use work.util_pkg.all;

architecture top_arch of top is
	signal x : std_ulogic_vector(31 downto 0);
begin

	counter_inst: entity work.counter
	generic map (
		WIDTH => x'length
	)
	port map (
		clk => clk,
		res_n => keys(0),
		en_n => not switches(0),
		x => x
	);

	process(all)
	begin
		aux <= (others => '0');
		aux(7 downto 0) <= std_logic_vector(x(7 downto 0));
	end process;

	hex0 <= to_segs(x(3 downto 0));
	hex1 <= to_segs(x(7 downto 4));
	hex2 <= to_segs(x(11 downto 8));
	hex3 <= to_segs(x(15 downto 12));
	hex4 <= to_segs(x(19 downto 16));
	hex5 <= to_segs(x(23 downto 20));
	hex6 <= to_segs(x(27 downto 24));
	hex7 <= to_segs(x(31 downto 28));

end architecture;
