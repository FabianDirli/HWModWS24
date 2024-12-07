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
	signal POLYNOMIAL : std_ulogic_vector := MAX_POLY_16;
	constant LFSR_WIDTH : integer := POLYNOMIAL'LENGTH;

	signal load_seed_n, en : std_ulogic;
	signal seed, seq     : std_ulogic_vector(LFSR_WIDTH-1 downto 0) := (others => '0');
	signal prdata : std_ulogic;

	constant CLK_PERIOD : time := 20 ns;
	signal shiftRegister : std_ulogic_vector(LFSR_WIDTH-1 downto 0) := (others => '0');
	signal initalValue := std_ulogic_vector(LFSR_WIDTH-1 downto 0);
	signal count : integer := 0;
	signal minPeriod : integer := integer'high;
	signal maxPeriod : integer := integer'low;
begin

	stimulus : process is
	begin

		res_n <= '0';
		wait for 2*CLK_PERIOD;
		res_n <= '1';

		-- loop through seed
		for i in 1 to 255 loop
			-- fill shift register
			wait for shiftRegister'LENGTH * CLK_PERIOD;
			-- save inital value
			initalValue <= shiftRegister;

			while shiftRegister /= initalValue loop
				count <= count + 1;
			end loop;

			if count < minPeriod then
				minPeriod <= count;
			end if;

			if count > maxPeriod then
				maxPeriod <= count;
			end if;

		end loop;


		

		-- Reset your module and apply stimuli

		wait;
	end process;

	shiftRegister_p : process (clk)
	begin
		if rising_edge(clk) then
			shiftRegister <= shiftRegister(shiftRegister'LENGTH downto 1) & prdata;
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

	clk_gen : process is
	begin
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;
	end process;

end architecture;
