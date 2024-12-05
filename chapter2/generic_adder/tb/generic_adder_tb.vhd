library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_adder_tb is
	generic (
		TESTMODE : string := "exhaustive"
	);
	constant N : positive := 8;
	signal A    : std_ulogic_vector(N-1 downto 0);
	signal B    : std_ulogic_vector(N-1 downto 0);

	signal S    : std_ulogic_vector(N-1 downto 0);
	signal Cout : std_ulogic;
	


end entity;

architecture bench of generic_adder_tb is
begin

	exhaustive_gen : if TESTMODE = "exhaustive" generate

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

	end generate;
	
end architecture;

