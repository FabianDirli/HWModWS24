library ieee;
use ieee.std_logic_1164.all;

entity lfsr is
	generic (
		LFSR_WIDTH : integer;
		POLYNOMIAL : std_ulogic_vector
	);
	port (
		clk         : in std_ulogic;
		res_n       : in std_ulogic;
		load_seed_n : in std_ulogic;
		seed        : in std_ulogic_vector(LFSR_WIDTH-1 downto 0);
		prdata      : out std_ulogic
	);
end entity;

architecture arch of lfsr is
	Signal mem : std_ulogic_vector(LFSR_WIDTH-1 downto 0);
	Signal xor_out : std_ulogic := 0;
begin

	xor_p : process 
	begin
		for i in N-1 downto 0 loop
			if POLYNOMIAL(i) = '1' then
				xor_out <= xor_out xor seed(i);
			end if;
		end loop;
	end process;

	shiftRegister_p : process (clk, res_n, load_seed_n)
	begin

		if res_n = '0' then
			mem <= (others => '0');
			xor_out <= '0';
		elsif load_seed_n = '0' then
			mem <= seed;
		elsif rising_edge(clk) then
			mem <= shift_left(unsigned(mem), 1);
			mem(0) <= xor_out;
			if load_seed_n '1' then
				prdata <= mem(LFSR_WIDTH-1);
		end if;

	end process;

end architecture;
