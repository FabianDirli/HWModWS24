
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util_pkg.all;

architecture top_arch_lfsr of top is
	signal x : std_ulogic_vector(3 downto 0);
	signal res_n : std_ulogic;
	signal cnt : std_ulogic_vector(21 downto 0);
	signal en : std_logic;
begin
	res_n <= keys(0);

	lfsr_inst : entity work.lfsr
	port map (
		clk => clk,
		res_n => res_n,
		en => en,
		x => x
	);
	ledg(3 downto 0) <= x;
	hex0 <= to_segs(x);
	
	hex1 <= SSD_CHAR_OFF;
	hex2 <= SSD_CHAR_OFF;
	hex3 <= SSD_CHAR_OFF;
	hex4 <= SSD_CHAR_OFF;
	hex5 <= SSD_CHAR_OFF;
	hex6 <= SSD_CHAR_OFF;
	hex7 <= SSD_CHAR_OFF;

	process(all)
	begin
		en <= '0';
		if switches(0) = '1' and unsigned(cnt) = 0 then
			en <= '1';
		end if;
	end process;

	sync : process (clk, res_n)
	begin
		if res_n = '0' then
			cnt <= (others => '0');
		elsif rising_edge(clk) then
			cnt <= std_ulogic_vector(unsigned(cnt) + 1);
		end if;
	end process;
	

end architecture;
