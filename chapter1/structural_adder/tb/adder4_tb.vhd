library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.adder4_pkg.all;

entity adder4_tb is
end entity;

architecture tb of adder4_tb is
	-- You might want to add some signals
	signal A, B, Sum : std_ulogic_vector(3 downto 0);
	signal Cin, Cout : std_ulogic;
begin

	-- Instantiate the unit under test (adder4)
	uut : entity work.adder4
	port map (
		A => A,
		B => B,
		Cin => Cin,
		S => Sum,
		Cout => Cout
	);

	-- Stimulus process
	stimulus: process
		-- implement this procedure!
		procedure test_values(value_a, value_b, value_cin : integer) is
		begin
			-- assert that Sum is correct
			assert to_integer(unsigned(Cout&Sum)) = value_a + value_b + value_cin report "Testcase " & to_string(value_a) & " + " & to_string(value_b) 
				& " with Cin = " & to_string(Cin) & " FAILED! Expected " & to_string(value_a + value_b + value_cin) & " but got " & to_string(to_integer(unsigned(Cout&Sum))) severity error;
			-- assert Cout is correct
			assert Cout = shift_right(to_unsigned(value_a+value_b+value_cin, 5), 4)(0) report "Testcase " & to_string(value_a) & " + " & to_string(value_b) 
				& " with Cin = " & to_string(Cin) & " FAILED! Expected Cout " & to_string(shift_right(to_unsigned(value_a+value_b+value_cin, 5), 4)(0)) & " but got " & to_string(Cout) severity error;
			end procedure;
	begin
		report "simulation start";
		
		-- Apply test stimuli
		for i in 0 to 15 loop
			A <= std_ulogic_vector(to_unsigned(i, A'length));
			for j in 0 to 15 loop
				B <= std_ulogic_vector(to_unsigned(j, B'length));
				for k in 0 to 1 loop
					Cin <= '1' when k = 1 else '0';
					wait for 10 ns;
					test_values(i,j,k);
					report "A: " & to_string(A) & " + B: " & to_string(B) & " + Cin: " & to_string(Cin) & " = " & to_string(Sum) & " + Cout = " & to_string(Cout);
				end loop;
			end loop;
		end loop;

		report "simulation end";
		-- End simulation
		wait;
	end process;
end architecture;

