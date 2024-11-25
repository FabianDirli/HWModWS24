
use work.util_pkg.all;

architecture top_arch of top is
begin
	demo : entity work.demo
	port map (
		a => switches(0),
		b => switches(1),
		x => ledg(0)
	);

	ledr <= switches;
	ledg(8 downto 1) <= (others=>'0');

	hex7 <= to_segs(x"2");
	hex6 <= to_segs(x"0");
	hex5 <= to_segs(x"2");
	hex4 <= to_segs(x"4");
	hex3 <= to_segs(switches(15 downto 12));
	hex2 <= to_segs(switches(11 downto 8));
	hex1 <= to_segs(switches(7 downto 4));
	hex0 <= to_segs(switches(3 downto 0));

end architecture;

