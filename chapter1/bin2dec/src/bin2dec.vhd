library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;
use work.bin2dec_pkg.all;

entity bin2dec is
	port (
		bin_in   : in  std_ulogic_vector;
		dec_out  : out integer;
		bcd_out  : out std_ulogic_vector
	);
end entity;

-- put your architecture here

architecture bin2dec_arch of bin2dec is
	type bcd_t is array(integer range <>) of std_logic_vector(3 downto 0);

	pure function decToBin (n : integer) return std_ulogic_vector is
		variable result : std_ulogic_vector (3 downto 0);
		variable dec : integer := n;
  	begin
		for i in 0 to 3 loop
			if dec mod 2 = 0 then
				result(i) := '0';
			else
				result(i) := '1';
			end if;
			dec := dec / 2;
		end loop;
		return result;
	end function;

	pure  function binToDec (bin : std_ulogic_vector) return integer is
		variable bin_cpy : std_ulogic_vector (bin'length-1 downto 0);
		variable result : integer := 0;
	begin
		bin_cpy := bin(bin'length-1 downto 0);
		for i in 0 to bin'length-1 loop
			result := result + 2 ** i when bin_cpy(0) = '1';
			bin_cpy := std_ulogic_vector(shift_right(unsigned(bin_cpy), 1));
		end loop;
		return result;
	end function;

	pure function decToBcd (dec : integer) return std_logic_vector is
		variable tmp : integer;
		variable result : std_logic_vector (bcd_out'length-1 downto 0);
		variable dec_cpy : integer := dec;
  	begin
		for i in 0 to log10c(dec)-1 loop
			tmp := dec_cpy mod 10;
			result(4*i+3 downto 4*i) := decToBin(tmp);
			dec_cpy := dec_cpy / 10;
		end loop;
		return result;
	end function;

	begin
	
		main : process (bin_in)
			variable tmp : integer;
			variable dec : integer;
		begin
			dec := binToDec(bin_in);
			dec_out <= dec;
			bcd_out <= decToBcd(dec);
		end process;

	

end architecture;