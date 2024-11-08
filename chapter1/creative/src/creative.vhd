library ieee;
use work.vhdldraw_pkg.all;
use ieee.math_real.all;

entity creative is
end entity;

architecture arch of creative is

	procedure draw_star(draw: inout vhdldraw_t; x, y, b : integer) is
	begin
		case b is
			when 0 =>
				draw.setColor(255, 255, 0);
			when 1 => 
				draw.setColor(255, 255, 100);
			when 2 => 
				draw.setColor(255, 255, 150);
			when 3 => 
				draw.setColor(255, 255, 200);
			when others =>
				draw.setColor(255, 0, 0);
		end case;
	
		draw.drawPoint(x, y);
		draw.drawPoint(x + 1, y);
		draw.drawPoint(x, y + 1);
		draw.drawPoint(x + 1, y + 1);
	end procedure;

begin

	process
		variable draw : vhdldraw_t;
		variable width : natural := 200;
		variable height : natural := 200;
		variable i : integer;
		variable x, y, b : real;
		variable star_count : natural := 20;
		variable seed1 : positive := 1;
    	variable seed2 : positive := 1;

	begin
		draw.init(width, height);

		-- set background color
		draw.clear(create_color(0, 0, 50));
		
		-- draw moon
		draw.setColor(200, 200, 200);
		draw.fillCircle(150, 50, 20);

		-- draw stars
		for i in 1 to star_count loop
			-- get random x and y
			uniform(seed1, seed2, x);
			uniform(seed1, seed2, y);
			uniform(seed1, seed2, b);
			draw_star(draw, integer(x * real(width)), integer(y * real(height)), integer(b * 3.0));
		end loop;
		
		i := 0;
		while i < star_count loop
			-- get random x and y
			uniform(seed1, seed2, x);
			uniform(seed1, seed2, y);
			uniform(seed1, seed2, b);
			if i mod 2 = 0 then
				draw_star(draw, integer(x * real(width)), integer(y * real(height)), integer(b * 3.0));
			else
				draw.drawPoint(integer(x * real(width)), integer(y * real(height))); -- small star
			end if;
			i := i + 1;
		end loop;
	
		draw.show("creative.ppm");

		wait;
	end process;
end architecture;
