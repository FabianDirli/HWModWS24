
# Util Package

The util support package `util_pkg` provides some convenient functions and constants you may need for various tasks.

## Dependencies
* None

## Required Files
 * `util_pkg.vhd`

## Supported Functions

* `function to_segs(value : in std_logic_vector(3 downto 0)) return std_logic_vector;`{.vhdl}
Converts the hexadecimal (4-bit) input value into a bit-pattern that can be displayed on a seven-segment display.

## Constants

Besides the 16 symbols required to display hexadecimal numbers, sevent-segment diplays also support a limited number of other symbols.
For that purpose the package defines a few constants:

 * `SSD_CHAR_OFF`
 * `SSD_CHAR_DASH`
 * `SSD_CHAR_A`
 * `SSD_CHAR_C`
 * `SSD_CHAR_E`
 * `SSD_CHAR_F`
 * `SSD_CHAR_G`
 * `SSD_CHAR_L`
 * `SSD_CHAR_O`
 * `SSD_CHAR_P`
 * `SSD_CHAR_OPENING_BRACKET`
 * `SSD_CHAR_CLOSING_BRACKET`
 * `SSD_CHAR_LC_B`
 * `SSD_CHAR_LC_D`
 * `SSD_CHAR_LC_I`
 * `SSD_CHAR_LC_R`