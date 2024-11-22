library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

use work.math_pkg.all;

package vhdldraw_pkg is
	type color_t is record
		red   : unsigned(7 downto 0);
		green : unsigned(7 downto 0);
		blue  : unsigned(7 downto 0);
	end record;

	type points_t is array(natural range <>) of integer;

	constant BLACK    : color_t := (others => (others => '0'));
	constant WHITE    : color_t := (others => (others => '1'));
	constant RED      : color_t := (red => x"FF", green => x"00", blue => x"00");
	constant GREEN    : color_t := (red => x"00", green => x"FF", blue => x"00");
	constant BLUE     : color_t := (red => x"00", green => x"00", blue => x"FF");
	constant CYAN     : color_t := (red => x"00", green => x"FF", blue => x"FF");
	constant YELLOW   : color_t := (red => x"FF", green => x"FF", blue => x"00");
	constant MAGENTA  : color_t := (red => x"FF", green => x"00", blue => x"FF");
	constant PURPLE   : color_t := (red => x"66", green => x"00", blue => x"CC");
	constant ORANGE   : color_t := (red => x"FF", green => x"80", blue => x"00");
	constant PINK     : color_t := (red => x"FF", green => x"AA", blue => x"AA");
	constant GRAY     : color_t := (red => x"80", green => x"80", blue => x"80");
	constant BROWN    : color_t := (red => x"80", green => x"40", blue => x"00");


	function create_color(r, g, b : natural) return color_t;
	function from_rgb332(r, g, b : natural) return color_t;

	type vhdldraw_t is protected
		procedure init(width : natural; height: natural);
		procedure init(size : natural);

		impure function getWidth return natural;
		impure function getHeight return natural;

		procedure setColor(color : color_t);
		procedure setColor(r, g, b : natural);
		impure function getColor return color_t;

		procedure setLineWidth(lineWidth : natural);
		impure function getLineWidth return natural;

		procedure clear(color : color_t := WHITE);
		procedure show(filename : string);

		procedure drawPoint(x, y : integer);
		procedure drawLine(x0, y0, x1, y1 : integer);

		procedure drawSquare(x, y : integer; size : integer);
		procedure drawRectangle(x, y : integer; width, height : integer);
		procedure drawCircle(centerX, centerY : integer; radius : natural);
		procedure drawEllipse(centerX, centerY :integer; horizontalRadius, verticalRadius : natural);
		procedure drawTriangle(x0, y0, x1, y1, x2, y2 : integer);
		procedure drawPolygon(vertices : points_t);

		procedure fillSquare(x, y : integer; size : integer);
		procedure fillRectangle(x, y : integer; width, height : integer);
		procedure fillEllipse(x, y : integer; horizontalRadius, verticalRadius : natural);
		procedure fillCircle(x, y : integer; radius : natural);
		procedure fillTriangle(x0, y0, x1, y1, x2, y2 : integer);
		procedure fillPolygon(vertices : points_t);
	end protected;
end package;

package body vhdldraw_pkg is
	-- the midpoint algorithm requires 64 bit for intermediate results if we do not want to overflow for even with small windows and shapes
	subtype int64_t is signed(63 downto 0);

	function to_int64_t(val : integer) return int64_t is begin
		return to_signed(val, int64_t'length);
	end function;

	function "*"(a, b : int64_t) return int64_t is
		variable tmp : signed(127 downto 0) := (others => '0');
	begin
		for i in a'range loop
			if a(i) ='1' then
				tmp(63+i downto i) := b + tmp(63+i downto i);
			end if;
		end loop;
		return tmp(63 downto 0);
	end function;

	function "*"(a : integer; b : int64_t) return int64_t is begin
		return to_int64_t(a) * b;
	end function;

	function "*"(a : int64_t; b : integer) return int64_t is begin
		return b * a;
	end function;

	-- limited to int64_t values with max 32 bits ... sufficient for our cases though
	function to_real(val : int64_t) return real is begin
		assert val(63 downto 32) = 32b"0" report "cannot convert int64_t value with 2^32-1";
		return real(to_integer(val));
	end function;

	function create_color(r, g, b : natural) return color_t is
		variable color : color_t;
	begin
		assert r <= 2**color.red'length-1 report "Red color component out of range";
		assert g <= 2**color.green'length-1 report "Green color component out of range";
		assert b <= 2**color.blue'length-1 report "Blue color component out of range";

		color.red := to_unsigned(r, color.red'length);
		color.green := to_unsigned(g, color.green'length);
		color.blue := to_unsigned(b, color.blue'length);

		return color;
	end function;

	function from_rgb332(r, g, b : natural) return color_t is
		variable color : color_t;
	begin
		assert r <= 7 report "Red color component out of range of RGB 3-3-2";
		assert g <= 7 report "Green color component out of range of RGB 3-3-2";
		assert b <= 3 report "Blue color component out of range of RGB 3-3-2";

		color.red :=   to_unsigned(integer(real(r) * 36.429), color.red'length);
		color.green := to_unsigned(integer(real(g) * 36.429), color.green'length);
		color.blue :=  to_unsigned(integer(real(b) * 85.0), color.blue'length);
		return color;
	end function;

	function min(constant a, b: in integer) return integer is
	begin
		if a < b then
			return a;
		end if;
		return b;
	end function;

	type vhdldraw_t is protected body
		type frame_t is array(natural range<>, natural range<>) of color_t;
		type frame_ptr_t is access frame_t;
		variable frame : frame_ptr_t := null;
		variable pen_color : color_t := BLACK;
		variable pen_width : natural := 1;

		procedure init(width: natural; height: natural) is
		begin
			if frame /= null then
				deallocate(frame);
			end if;
			frame := new frame_t(0 to height-1, 0 to width-1);
			for y in 0 to frame'length(1)-1 loop
				for x in 0 to frame'length(2)-1 loop
					frame(y, x) := WHITE;
				end loop;
			end loop;
		end procedure;

		procedure init(size : natural) is
		begin
			init(size, size);
		end procedure;

		procedure setColor(color : color_t) is
		begin
			pen_color := color;
		end procedure;

		procedure setColor(r, g, b : natural) is
		begin
			pen_color := create_color(r, g, b);
		end procedure;

		procedure setLineWidth(lineWidth : natural) is
		begin
			pen_width := lineWidth;
		end procedure;

		impure function getLineWidth return natural is
		begin
			return pen_width;
		end function;

		impure function getColor return color_t is
		begin
			return pen_color;
		end function;

		impure function getWidth return natural is
		begin
			return frame'length(2);
		end function;

		impure function getHeight return natural is
		begin
			return frame'length(1);
		end function;

		procedure setPixel(x, y : integer) is
		begin
-- assert ((y < frame'length(1)) and (x < frame'length(2))) report "Coordinate (" & to_string(x) & "," & to_string(y) & ") out of frame boundaries" severity failure;
			if y >= 0 and y < frame'length(1) and x >= 0 and x < frame'length(2) then
				frame(y, x) := pen_color;
			end if;
		end procedure;

		procedure drawPoint(x, y : integer) is
			variable lw : natural := getLineWidth;
		begin
			if lw = 1 then
				setPixel(x, y);
			else
				setLineWidth(1);
				fillCircle(x, y, lw / 2);
				setLineWidth(lw);
			end if;
		end procedure;

		-- Convenience overload for use in midpoint algorithm
		procedure drawPoint(x, y : int64_t) is begin
			drawPoint(to_integer(x), to_integer(y));
		end procedure;

		-- Bresenham's algorithm
		procedure drawLine(x0, y0, x1, y1 : integer) is
			constant dx : integer := abs(x1 - x0);
			constant dy : integer := -abs(y1 - y0);
			variable sx, sy, err, e2 : integer;
			variable x : integer := x0;
			variable y : integer := y0;
		begin
			sx := 1 when x0 < x1 else -1;
			sy := 1 when y0 < y1 else -1;
			err := dx + dy;

			while true loop
				drawPoint(x,y);
				if x = x1 and y = y1 then
					exit;
				end if;
				e2 := 2 * err;
				if e2 > dy then
					err := err + dy;
					x := x + sx;
				end if;
				if e2 < dx then
					err := err + dx;
					y := y + sy;
				end if;
			end loop;
		end procedure;

		-- convenience overload for use in midpoint algorithm
		procedure drawLine(x0, y0, x1, y1 : int64_t) is begin
			drawLine(to_integer(x0), to_integer(y0), to_integer(x1), to_integer(y1));
		end procedure;

		procedure drawRectangle(x, y : integer; width, height : integer) is
		begin
			drawPolygon((x,y, x+width-1,y, x+width-1,y+height-1, x,y+height-1));
		end procedure;

		procedure drawSquare(x, y : integer; size : integer) is
		begin
			drawRectangle(x, y, size, size);
		end procedure;

		procedure midpointAlgorithm(x, y, a, b: integer; fill : boolean) is
			constant a2 : int64_t := to_int64_t(a * a);
			constant b2 : int64_t := to_int64_t(b * b);
			variable dx : int64_t := to_int64_t(0);
			variable dy : int64_t := 2 * a2 * b;
			variable d  : int64_t := b2 - (a2 * b) + to_int64_t(integer(to_real(a2) * 0.25));
			variable row : int64_t := to_int64_t(b);
			variable col : int64_t := to_int64_t(0);
		begin
			while (dx < dy) loop
				if fill then
					drawLine(x + col, y + row, x - col, y + row);
					drawLine(x + col, y - row, x - col, y - row);
				else
					drawPoint(x + col, y + row);
					drawPoint(x + col, y - row);
					drawPoint(x - col, y + row);
					drawPoint(x - col, y - row);
				end if;

				if (d < 0) then
						col := col + 1;
						dx := dx + 2 * b2;
						d := d + dx + b2;
				else
						col := col + 1;
						row := row - 1;
						dx := dx + 2 * b2;
						dy := dy - 2 * a2;
						d := d + dx - dy + b2;
				end if;
			end loop;

			d := to_int64_t(integer(to_real(b2) * (to_real(col) + 0.5) * (to_real(col) + 0.5))) + a2 * (row-1) * (row-1) - a2 * b2;

			while (row >= 0) loop
				if fill then
					drawLine(x + col, y + row, x - col, y + row);
					drawLine(x + col, y - row, x - col, y - row);
				else
					drawPoint(x + col, y + row);
					drawPoint(x - col, y + row);
					drawPoint(x + col, y - row);
					drawPoint(x - col, y - row);
				end if;

				if (d > 0) then
						row := row - 1;
						dy := dy - 2 * a2;
						d := d + a2 - dy;
				 else
						col := col + 1;
						row := row - 1;
						dx := dx + 2 * b2;
						dy := dy - 2 * a2;
						d := d + dx - dy + a2;
				 end if;
			end loop;
		end procedure;

		procedure drawEllipse(centerX, centerY : integer; horizontalRadius, verticalRadius : natural) is
		begin
			midpointAlgorithm(centerX, centerY, horizontalRadius, verticalRadius, False);
		end procedure;

		procedure drawCircle(centerX, centerY : integer; radius : natural) is
		begin
			midpointAlgorithm(centerX, centerY, radius, radius, False);
		end procedure;

		procedure drawPolygon(vertices : points_t) is
			constant maxIdx : natural := vertices'length / 2;
			variable nextIdx : natural;
		begin
			assert vertices'length mod 2 = 0 report "Array of vertices passed to drawPolygon must have an even length!" severity failure;
			for i in 0 to maxIdx-1 loop
				nextIdx := (i+1) mod maxIdx;
				drawLine(vertices(2*i), vertices(2*i+1), vertices(2*nextIdx), vertices(2*nextIdx+1));
			end loop;
		end procedure;

		procedure drawTriangle(x0, y0, x1, y1, x2, y2 : integer) is
		begin
			drawPolygon((x0, y0, x1, y1, x2, y2));
		end procedure;

		-- Even-odd algorithm for checking if a point is inside a polygon
		function evenOddRule(x, y: integer; points : points_t) return boolean is
			constant maxIdx : natural := points'length / 2;
			variable inside : boolean := False;
			variable x0, x1, y0, y1 :integer;
			variable slope : integer;
			variable nextIdx : natural;
		begin
			for i in 0 to maxIdx-1 loop
				nextIdx := (i+1) mod maxIdx;
				x1 := points(2*i);
				y1 := points(2*i+1);
				x0 := points(2*nextIdx);
				y0 := points(2*nextIdx+1);
				if y0 = y1 and y0 = y then
					if x >= min(x0, x1) and x <= max(x0, x1) then
						return True;
					end if;
				elsif (y0 >= y) /= (y1 >= y) then
					slope := (x - x0) * (y1 - y0) - (x1 - x0) * (y - y0);
					if slope = 0 then
						return True;
					elsif (slope < 0) /= (y1 < y0) then
						inside := not inside;
					end if;
				end if;
			end loop;
			return inside;
		end function;

		procedure fillPolygon(vertices : points_t) is
			constant maxIdx : natural := vertices'length / 2;
			variable nextIdx : natural;
			variable max_x, max_y : integer := 0;
			variable min_y : integer := frame'length(1);
			variable min_x : integer := frame'length(2);
		begin
			assert vertices'length mod 2 = 0 report "Array of vertices passed to drawPolygon must have an even length!" severity failure;
			-- Bounding box of polygon
			for i in 0 to maxIdx-1 loop
				max_x := min(max(vertices(2*i), max_x), frame'length(2));
				max_y := min(max(vertices(2*i+1), max_y), frame'length(1));
				min_x := max(0, min(vertices(2*i), min_x));
				min_y := max(0, min(vertices(2*i+1), min_y));
			end loop;

			-- Iterate over bounding box and fill points inside the polygon
			for y in min_y to max_y loop
				for x in min_x to max_x loop
					if evenOddRule(x, y, vertices) then
						setPixel(x, y);
					end if;
				end loop;
			end loop;
		end procedure;

		procedure fillTriangle(x0, y0, x1, y1, x2, y2 : integer) is
		begin
			fillPolygon((x0, y0, x1, y1, x2, y2));
		end procedure;

		procedure fillRectangle(x, y : integer; width, height : integer) is
		begin
			fillPolygon((x,y, x+width-1,y, x+width-1,y+height-1, x,y+height-1));
		end procedure;

		procedure fillSquare(x, y : integer; size : integer) is
		begin
			fillRectangle(x, y, size, size);
		end procedure;

		procedure fillEllipse(x, y : integer; horizontalRadius, verticalRadius : natural) is
		begin
			midpointAlgorithm(x, y, horizontalRadius, verticalRadius, True);
		end procedure;

		procedure fillCircle(x, y : integer; radius : natural) is
		begin
			midpointAlgorithm(x, y, radius, radius, True);
		end procedure;

		procedure clear(color : color_t := WHITE) is
			constant tmp : color_t := pen_color;
		begin
			setColor(color);
			fillRectangle(0, 0, frame'length(1), frame'length(2));
			setColor(tmp);
		end procedure;

		procedure show(filename : string) is
			file f_img : text;
			variable img_line : line;
			variable c : color_t;
			variable r, g, b : integer;
			constant height : natural := frame'length(1);
			constant width : natural := frame'length(2);
		begin
			file_open(f_img, filename, write_mode);
			-- add header
			swrite(img_line, "P3");
			writeline(f_img, img_line);
			swrite(img_line, to_string(width) & " " & to_string(height));
			writeline(f_img, img_line);
			swrite(img_line, to_string(2**8-1));
			writeline(f_img, img_line);
			for y in 0 to height-1 loop
				for x in 0 to width-1 loop
					c := frame(y, x);
					r := to_integer(c.red);
					g := to_integer(c.green);
					b := to_integer(c.blue);
					if x /= 0 then
						swrite(img_line, "  ");
					end if;
					swrite(img_line, integer'image(r) & " " & integer'image(g) & " " & integer'image(b));
				end loop;
				writeline(f_img, img_line);
			end loop;
			file_close(f_img);
		end procedure;

	end protected body;
end package body;
