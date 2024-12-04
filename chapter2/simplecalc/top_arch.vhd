library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util_pkg.all;

architecture top_arch_simplecalc of top is
	constant DATA_WIDTH : natural := 8;
	signal operand1 : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	signal operand2 : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	signal result   : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
begin
	
	/*
	uut : entity work.simplecalc
	generic map(
		DATA_WIDTH => DATA_WIDTH
	)
	port map (
		clk => clk,
		res_n => keys(0),
		operand_data_in => switches(7 downto 0),
		sub => switches(17),
		store_operand1 => keys(1),
		store_operand2 => keys(2),
		operand1 => operand1,
		operand2 => operand2,
		result => result
	);
	*/
	operand1 <= "01000110";
	hex7 <= to_segs(operand1(7 downto 4));
	hex6 <= to_segs(operand1(3 downto 0));
	hex5 <= to_segs(operand2(7 downto 4));
	hex4 <= to_segs(operand2(3 downto 0));
	hex3 <= to_segs(result(7 downto 4));
	hex2 <= to_segs(result(3 downto 0));
end architecture;
