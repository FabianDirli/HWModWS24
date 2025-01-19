library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.math_pkg.all;
use work.barcode_pkg.all;
use work.vhdldraw_pkg.all;

entity barcode is
end entity;

architecture arch of barcode is

begin
	barcode_maker : process
		constant bar_width : natural := 2;                -- Width of a single bar ("module" in Wikipedia article)
		constant quiet_zone : natural := 15 * bar_width;  -- "quite zone" of the code (a bit more than in the Wikipedia article)
		constant input_str: string := "1234567890(=)";

		variable vhdldraw : vhdldraw_t;

		variable width : natural := (input_str'length + 3) * BARCODE_BITS * bar_width + 2 * quiet_zone;	-- determine based on input string
		variable bar_height : natural := width / 5;           -- Calculate based on window width	
		variable y_pos : natural := width/10;                -- y position for the barcode bars
		variable x_pos : natural := quiet_zone;  -- x position for drawing

		-----------

		type output_array_t is array(0 to input_str'length + 2) of std_ulogic_vector(0 to 10);
		variable output_array : output_array_t;
		variable test : character := 'H';
		variable sum : integer := 0;

	begin

		output_array(0) := code128_table(104);	-- Start Code B
		sum := sum + 104;

		for i in 1 to input_str'length loop
			output_array(i) := code128_table(character'pos(input_str(i)) - 32);
			sum := sum + (character'pos(input_str(i)) - 32) * i;
		end loop;

		output_array(output_array'length - 2) := code128_table(sum rem 103);	-- Check sum
		output_array(output_array'length - 1) := code128_table(106);	-- Stop code;

		-- Initialize drawing window (having width / 10 as top and bottom margin looks nice,  / 10 works as bar height)
		vhdldraw.init(width, width / 5 + bar_height); -- This is just a dummy initialization -> adjust for total barcode width
		
		for i in 0 to output_array'length -1 loop
			for j in 0 to 10 loop
				if output_array(i)(j) = '0' then
					vhdldraw.setColor(create_color(255, 255, 255));
				else
					vhdldraw.setColor(create_color(0, 0, 0));
				end if;

				vhdldraw.fillRectangle(x_pos, y_pos, bar_width, bar_height);
				x_pos := x_pos + bar_width;
			end loop;
		end loop;

		-- Show the resulting barcode image
		vhdldraw.show(input_str & "_barcode.ppm");

		wait;  -- Wait indefinitely
	end process;
end architecture;
