library ieee;
use ieee.std_logic_1164.all;
use work.math_pkg.all;

architecture top_arch of top is
	constant POLY : std_ulogic_vector(7 downto 0) := "10111000";
	signal res_n : std_ulogic;
	signal prdata : std_ulogic;
	signal currentState : std_ulogic;
begin

	res_n <= keys(0);

	lfsr_inst : entity work.lfsr
	generic map(
		LFSR_WIDTH => POLY'length,
		POLYNOMIAL => POLY
	)
	port map(
		clk         => clk,
		res_n       => res_n,
		load_seed_n => keys(1),
		seed        => switches(POLY'length-1 downto 0),
		prdata      => prdata
	);

	-- set ledr(0) to prdata when keys(2) pressed
	ledr(0) <= currentState;
	
	process (clk)
	begin
		if res_n = '0' then
			currentState <= '1';
		elsif rising_edge(clk) then
			if keys(2) = '0' then
				currentState <= prdata;
			end if;
		end if;
	end process;
	

end architecture;
