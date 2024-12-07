
library ieee;
use ieee.std_logic_1164.all;
use work.util_pkg.all;

architecture top_arch_generic_adder of top is
	constant bit8 : boolean := false;
begin
	
	gen : 

	if bit8 generate
		constant N : natural := 4;
		signal S : std_ulogic_vector(N-1 downto 0);
	begin
		uut : entity work.generic_adder 
		generic map (
			N => N
		)
		port map(
			B => switches(N-1 downto 0),
			A => switches(N-1+8 downto 8),
			S => S,
			Cout => ledg(0)
		);
		
		hex0 <= to_segs("0000");
		hex1 <= to_segs("0000");
		hex3 <= to_segs("0000");
		hex5 <= to_segs("0000");
		hex7 <= to_segs("0000");
		
		
		hex4 <= to_segs(switches(N-1 downto 0));
		hex6 <= to_segs(switches(N-1+8 downto 8));
		hex2 <= to_segs(S);
	end;
	else generate
		constant N : natural := 8;
		signal S : std_ulogic_vector(N-1 downto 0);
	begin
		uut : entity work.generic_adder
		generic map (
			N => N
		)
		port map(
			B => switches(N-1 downto 0),
			A => switches(N-1+8 downto 8),
			S => S,
			Cout => ledg(0)
		);

		hex0 <= to_segs("0000");
		hex1 <= to_segs("0000");
		
		hex7 <= to_segs(switches(15 downto 12));
		hex6 <= to_segs(switches(11 downto 8));
		hex5 <= to_segs(switches(7 downto 4));
		hex4 <= to_segs(switches(3 downto 0));
		hex3 <= to_segs(S(7 downto 4));
		hex2 <= to_segs(S(3 downto 0));
	end;
	end generate;
	
	

end architecture;
