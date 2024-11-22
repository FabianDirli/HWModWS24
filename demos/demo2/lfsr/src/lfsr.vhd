
library ieee;
use ieee.std_logic_1164.all;

entity lfsr is
	port (
		clk   : in  std_ulogic;
		res_n : in  std_ulogic;
		en    : in  std_ulogic;
		x     : out std_ulogic_vector(3 downto 0)
	);
end entity;

architecture arch of lfsr is
begin

	process (clk, res_n)
	begin
		if res_n = '0' then
			x <= (0=>'1', others => '0');
		elsif rising_edge(clk) then
			if en = '1' then
				x(0) <= x(3) xor x(2);
				x(1) <= x(0);
				x(2) <= x(1);
				x(3) <= x(2);
			end if;
		end if;
	end process;

end architecture;

