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

	signal stop : boolean := false;
	constant CLK_PERIOD : time := 20 ns;
	constant startValue1 : natural := 4;
	constant startValue2 : natural := 3;

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
		
		res_n <= '0';
		wait for 2*CLK_PERIOD;
		res_n <= '1';

		wait for CLK_PERIOD;

		for i in 1 to 4 loop
			-- Store first operand
			operand_data_in <= std_logic_vector(to_unsigned(startValue1*(2**i), DATA_WIDTH));
			store_operand1 <= '0';
			wait for 2*CLK_PERIOD;
			store_operand1 <= '1';
			
			-- Store second operand
			operand_data_in <= std_logic_vector(to_unsigned(startValue2*(2**i), DATA_WIDTH));
			store_operand2 <= '0';
			wait for 2*CLK_PERIOD;
			store_operand2 <= '1';

			-- Switch calculation method
			if sub = '1' then
				report to_string(startValue1*(2**i)) & " - "  & to_string(startValue2*(2**i)) & " = " & to_string(to_integer(unsigned(result))); 
				assert startValue1*(2**i) - startValue2*(2**i) = to_integer(unsigned(result)) report "WRONG" severity error;
				sub <= '0';
			else 
				report to_string(startValue1*(2**i)) & " + "  & to_string(startValue2*(2**i)) & " = " & to_string(to_integer(unsigned(result))); 
				assert startValue1*(2**i) + startValue2*(2**i) = to_integer(unsigned(result)) report "WRONG" severity error;
				sub <= '1';
			end if;
			
		end loop;
		
		report "simulation end";
		-- End simulation
		stop <= true;
		wait;
	end process;

	clk_p : process
	begin
		while not stop loop
			clk <= '0';
			wait for CLK_PERIOD / 2;
			clk <= '1';
			wait for CLK_PERIOD / 2;
		end loop;
		wait;
	end process;

end architecture;

