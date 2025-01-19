library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
begin

	prdata <= mem(LFSR_WIDTH-1);

	shiftRegister_p : process (clk, res_n, load_seed_n)
		variable xor_out : std_ulogic := '0';
		variable shifted_mem : std_ulogic_vector(LFSR_WIDTH-1 downto 0);
	begin

		if res_n = '0' then
			mem <= (others => '0');
		elsif rising_edge(clk) then
			if load_seed_n = '1' then
				shifted_mem := mem(LFSR_WIDTH-2 downto 0) & '0';
				xor_out := '0';
				for i in POLYNOMIAL'length-1 downto 0 loop
					if POLYNOMIAL(i) = '1' then
						xor_out := xor_out xor mem(i);
					end if;
				end loop;
				shifted_mem(0) := xor_out;
				mem <= shifted_mem;
			elsif load_seed_n = '0' then
				mem <= seed;
			end if;
		end if;
	end process;

end architecture;
