
library ieee;
use ieee.std_logic_1164.all;

package util_pkg is

	constant SSD_CHAR_OFF  : std_ulogic_vector(6 downto 0) := "1111111";
	constant SSD_CHAR_DASH : std_ulogic_vector(6 downto 0) := "0111111";
	constant SSD_CHAR_A    : std_ulogic_vector(6 downto 0) := "0001000";
	constant SSD_CHAR_C    : std_ulogic_vector(6 downto 0) := "1000110";
	constant SSD_CHAR_E    : std_ulogic_vector(6 downto 0) := "0000110";
	constant SSD_CHAR_F    : std_ulogic_vector(6 downto 0) := "0001110";
	constant SSD_CHAR_G    : std_ulogic_vector(6 downto 0) := "1000010";
	constant SSD_CHAR_L    : std_ulogic_vector(6 downto 0) := "1000111";
	constant SSD_CHAR_O    : std_ulogic_vector(6 downto 0) := "1000000";
	constant SSD_CHAR_P    : std_ulogic_vector(6 downto 0) := "0001100";

	constant SSD_CHAR_OPENING_BRACKET : std_ulogic_vector(6 downto 0) := "1000110";
	constant SSD_CHAR_CLOSING_BRACKET : std_ulogic_vector(6 downto 0) := "1110000";

	constant SSD_CHAR_LC_B : std_ulogic_vector(6 downto 0) := "0000011";
	constant SSD_CHAR_LC_D : std_ulogic_vector(6 downto 0) := "0100001";
	constant SSD_CHAR_LC_I : std_ulogic_vector(6 downto 0) := "1101111";
	constant SSD_CHAR_LC_R : std_ulogic_vector(6 downto 0) := "0101111";

	function to_segs(value : in std_ulogic_vector(3 downto 0)) return std_ulogic_vector;
end package;

package body util_pkg is
	---------------------------------------
	-- Seven segment display
	---------------------------------------
	--         0
	--       -----
	--    5 |     | 1
	--      |  6  |
	--       -----
	--    4 |     | 2
	--      |  3  |
	--       -----

	function to_segs(value : in std_ulogic_vector(3 downto 0)) return std_ulogic_vector is
	begin
		case value is
			when x"0" => return "1000000";
			when x"1" => return "1111001";
			when x"2" => return "0100100";
			when x"3" => return "0110000";
			when x"4" => return "0011001";
			when x"5" => return "0010010";
			when x"6" => return "0000010";
			when x"7" => return "1111000";
			when x"8" => return "0000000";
			when x"9" => return "0010000";
			when x"A" => return SSD_CHAR_A;
			when x"B" => return SSD_CHAR_LC_B;
			when x"C" => return SSD_CHAR_C;
			when x"D" => return SSD_CHAR_LC_D;
			when x"E" => return SSD_CHAR_E;
			when x"F" => return SSD_CHAR_F;
			when others => return SSD_CHAR_OFF;
		end case;
	end function;

end package body;

