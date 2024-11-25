library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lfsr_tb is
end entity;

architecture tb of lfsr_tb is
	signal clk, res_n : std_ulogic := '0';

	constant MAX_POLY_8  : std_ulogic_vector(7 downto 0)  := "10111000";
	constant POLY_8      : std_ulogic_vector(7 downto 0)  := "10100100";
	constant MAX_POLY_16 : std_ulogic_vector(15 downto 0) := "1101000000001000";
	constant POLY_16     : std_ulogic_vector(15 downto 0) := "1101001100001000";

	-- Change as required
	constant POLYNOMIAL : std_ulogic_vector := MAX_POLY_16;
	constant LFSR_WIDTH : integer := POLYNOMIAL'LENGTH;

	signal load_seed_n, en : std_ulogic;
	signal seed, seq     : std_ulogic_vector(LFSR_WIDTH-1 downto 0) := (others => '0');
	signal prdata : std_ulogic;
begin

	stimulus : process is
	begin

		-- Reset your module and apply stimuli

		wait;
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
		-- generate a 50MHz clock signal
	end process;

end architecture;
