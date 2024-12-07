library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_adder_tb is
	generic (
		TESTMODE : string := "fibonaasdcci"
	);
	
end entity;

architecture bench of generic_adder_tb is
begin

	testmode_gen : 
	if exhaustive : TESTMODE = "exhaustive" generate
		constant N : positive := 8;
		signal A    : std_ulogic_vector(N-1 downto 0);
		signal B    : std_ulogic_vector(N-1 downto 0);

		signal S    : std_ulogic_vector(N-1 downto 0);
		signal Cout : std_ulogic;
	begin
		uut : entity work.generic_adder
		generic map (
			N => 8
		)
		port map (
			A => A,
			B => B,
			S => S,
			Cout => Cout
		);

		exhaustive_p : process
		begin
			for i in 0 to 2**N-1 loop
				for j in 0 to 2**N-1 loop
					A <= std_ulogic_vector(to_unsigned(i, N));
					B <= std_ulogic_vector(to_unsigned(j, N));
					wait for 1 ns;
					if i+j > 2**N-1 then
						assert i+j-2**N = to_integer(unsigned(S))
							report "Result WRONG: " & to_string(i) & " + " & to_string(j) & " = " & to_string(to_integer(unsigned(S))) & " + Cout = " & to_string(Cout) severity error;
					else 
						assert i+j = to_integer(unsigned(S))
							report "Result SUM WRONG! " severity error;
					end if;
					
						
					if i+j > 2**N-1 then
						assert Cout = '1' 
							report "Result CARRY WRONG!" severity error;
					else 
						assert Cout = '0' 
							report "Result CARRY WRONG!" severity error;
					end if;
				end loop;
			end loop; 

			wait;
		end process;

	elsif fibonacci : TESTMODE = "fibonacci" generate
		constant N : positive := 32;
		signal A    : std_ulogic_vector(N-1 downto 0);
		signal B    : std_ulogic_vector(N-1 downto 0);

		signal S    : std_ulogic_vector(N-1 downto 0);
		signal Cout : std_ulogic;
		signal x, y : std_ulogic_vector(N-1 downto 0);
		signal steps : natural := 0;
	begin
		uut : entity work.generic_adder
		generic map (
			N => N
		)
		port map (
			A => A,
			B => B,
			S => S,
			Cout => Cout
		);

		fibonacci_p : process
		begin

			x <= (others => '0');
			y <= (0 => '1', others => '0');
			wait for 1 ns;

			while Cout /= '1' loop
				A <= x;
				B <= y;
				wait for 1 ns;	

				x <= B;
				y <= S;	
				wait for 1 ns;
				steps <= steps + 1;

			end loop;
			report "Fibonacci number is 2^32 + " & to_string(to_integer(unsigned(S))) & " and took " & to_string(n) & " steps." severity Error;
			wait;
		end process;
	else error : generate
	begin
		asd : process
		begin
			report "asd" severity error;
			--report "No suitable testmode to execute for '" & TESTMODE & "'. Choose beetween 'exhaustive' and 'fibonacci'" severity Error;
			wait;
		end process;
	end generate; 

end architecture;

