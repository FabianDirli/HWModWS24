library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package sram_ctrl_pkg is
	type sram_access_mode_t is (
		BYTE,
		-- MID, -- experimental feature, outcome undefined
		WORD);

	subtype byte_addr_t is std_ulogic_vector(20 downto 0);
	subtype word_addr_t is std_logic_vector(19 downto 0);

	subtype uword_t is std_ulogic_vector(15 downto 0);
	subtype word_t is std_logic_vector(15 downto 0);
	type sequence_t is array(natural range <>) of uword_t;

end package;
