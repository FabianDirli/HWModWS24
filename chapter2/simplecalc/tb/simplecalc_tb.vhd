library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity simplecalc_tb is
end entity;

architecture bench of simplecalc_tb is

	
	constant DATA_WIDTH : natural := 8;
	
	signal clk    : std_ulogic;
	signal res_n  : std_ulogic := '1';

	signal operand_data_in : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	signal store_operand1  : std_ulogic := '1';
	signal store_operand2  : std_ulogic := '1';

	signal sub : std_ulogic := '0'; 

	signal operand1 : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	signal operand2 : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	signal result   : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '0');

begin

	-- Instantiate the unit under test

	uut : entity work.simplecalc
	generic map (
		DATA_WIDTH => DATA_WIDTH
	)
	port map (
		clk => clk,
		res_n => res_n,
		operand_data_in => operand_data_in,
		store_operand1 => store_operand1,
		store_operand2 => store_operand2,
		sub => sub,
		operand1 => operand1,
		operand2 => operand2,
		result => result
	);

	-- Stimulus process
	stimulus: process
	begin
		report "simulation start";

		-- Apply test stimuli
		
		wait for 15 ns;

		operand_data_in <= std_logic_vector(to_unsigned(13, DATA_WIDTH));
		store_operand1 <= '0';
		wait for 30 ns;
		store_operand1 <= '1';
		operand_data_in <= std_logic_vector(to_unsigned(17, DATA_WIDTH));
		store_operand2 <= '0';
		wait for 30 ns;
		store_operand2 <= '1';
		
		report "Result: " & to_string(unsigned(result));

		report "simulation end";
		-- End simulation
		wait;
	end process;

	clk_p : process
	begin
		clk <= '0';
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
	end process;

end architecture;

