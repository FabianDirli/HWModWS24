library ieee;
use ieee.std_logic_1164.all;

entity lfsr_tb is
end entity;

architecture bench of lfsr_tb is
	signal clk : std_ulogic;
	signal res_n : std_ulogic;
	signal en: std_ulogic;
	signal x : std_ulogic_vector(3 downto 0);

	constant CLK_PERIOD : time := 20 ns;
	signal stop : boolean := false;

	type ref_value_t is array(integer range <>) of std_ulogic_vector(3 downto 0);
	constant ref_value : ref_value_t(0 to 7) := (
		"0001",
		"0010",
		"0100",
		"1001",
		"0011",
		"0110",
		"1101",
		"1010"
	);
begin

	uut : entity work.lfsr
	port map (
		clk => clk,
		res_n => res_n,
		en => en,
		x => x
	);

	clkgen : process
	begin
		while not stop loop
			clk <= '0';
			wait for CLK_PERIOD/2;
			clk <= '1';
			wait for CLK_PERIOD/2;
		end loop;
		wait;
	end process;

	stimulus : process
	begin
		res_n <= '0';
		en <= '0';
		wait until rising_edge(clk);
		wait for 2*CLK_PERIOD;
		res_n <= '1';

		wait for CLK_PERIOD;

		en <= '1';
		for i in 0 to 7 loop
			assert x = ref_value(i) report "expected: " & to_string(ref_value(i)) & ", actual: " & to_string(x) severity error;
			wait for CLK_PERIOD;
		end loop;

		stop <= true;
		wait;
	end process;
end architecture;
