library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lfsr_tb is
end entity;

architecture tb of lfsr_tb is
	signal clk : std_ulogic := '0';
	signal res_n : std_ulogic := '1';

	constant MAX_POLY_8  : std_ulogic_vector(7 downto 0)  := "10111000";
	constant POLY_8      : std_ulogic_vector(7 downto 0)  := "10100100";
	constant MAX_POLY_16 : std_ulogic_vector(15 downto 0) := "1101000000001000";
	constant POLY_16     : std_ulogic_vector(15 downto 0) := "1101001100001000";

	-- Change as required
	constant POLYNOMIAL : std_ulogic_vector := POLY_16;
	constant LFSR_WIDTH : integer := POLYNOMIAL'LENGTH;

	signal load_seed_n, en : std_ulogic;
	signal seed, seq     : std_ulogic_vector(LFSR_WIDTH-1 downto 0) := (others => '0');
	signal prdata : std_ulogic;

	constant CLK_PERIOD : time := 20 ns;
	signal shiftRegister : std_ulogic_vector(LFSR_WIDTH-1 downto 0) := (others => '0');
	signal finished : boolean := false;


begin

	stimulus : process is
		variable initalValue : std_ulogic_vector(LFSR_WIDTH-1 downto 0);
		variable count : integer := 0;
		variable minPeriod : integer := integer'high;
		variable maxPeriod : integer := integer'low;
	begin

		-- loop through seed
		for i in 678 to 750 loop
			-- reset
			res_n <= '0';
			wait for 2*CLK_PERIOD;
			res_n <= '1';
			count := 0;

			-- load seed
			seed <= std_ulogic_vector(to_unsigned(i, seed'length));
			load_seed_n <= '0';
			wait for CLK_PERIOD;
			load_seed_n <= '1';

			-- fill shift register
			wait for shiftRegister'LENGTH * CLK_PERIOD ;
			wait for CLK_PERIOD;
			-- save inital value
			initalValue := shiftRegister;
			wait for CLK_PERIOD;

			while shiftRegister /= initalValue loop
				wait until rising_edge(clk);
				count := count + 1;
				--report "state: " & to_string(unsigned(shiftRegister));
			end loop;

			report "seed: " & to_string(i) & ", period: " & to_string(count);

			if count < minPeriod then
				minPeriod := count;
			end if;

			if count > maxPeriod then
				maxPeriod := count;
			end if;
		end loop;

		report "min period: " & to_string(minPeriod) & ", max period: " & to_string(maxPeriod);
		finished <= true;
		wait for 1 ns;
		wait;
	end process;

	shiftRegister_p : process (clk)
	begin
		if rising_edge(clk) and load_seed_n = '1' then
			shiftRegister <= shiftRegister(shiftRegister'LENGTH-2 downto 0) & prdata;
		end if;
	end process;

	uut : entity work.lfsr
	generic map (
		LFSR_WIDTH => LFSR_WIDTH,
		POLYNOMIAL => POLYNOMIAL
	)
	port map (
		clk => clk,
		res_n => res_n,
		load_seed_n => load_seed_n,
		seed => seed,
		prdata => prdata
	);

	clk_gen : process
	begin
		while not finished loop
			clk <= '0';
			wait for CLK_PERIOD/2;
			clk <= '1';
			wait for CLK_PERIOD/2;
		end loop;
		wait;
	end process;

end architecture;
