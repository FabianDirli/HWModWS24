library ieee;
use ieee.math_real.all;

use work.vhdldraw_pkg.all;
use work.math_pkg.all;

entity sorting is
end entity;

architecture arch of sorting is
	type int_arr_t is array(integer range<>) of integer;

	procedure swap(data : inout int_arr_t; i, j : in integer) is
		variable buf : integer;
	begin
		buf := data(i);
		data(i) := data(j);
		data (j) := buf;
	end procedure;

	procedure partition(data : inout int_arr_t; low, high : in integer; k : inout integer) is
	begin
		k := low;
		for i in k to high loop 
			if data(i) < data(high) then
				swap(data, i, k);
				k := k + 1;
			end if;
		end loop;
		swap(data, k, high);
	end procedure;

	procedure quicksort(data : inout int_arr_t; low, high : integer) is
		variable j : integer;
	begin
		if high > low then
			partition(data, low, high, j);
			quicksort(data, low, j-1);
			quicksort(data, j+1, high);
		end if;
	end procedure;

	-- You can use this for debugging
	procedure print_array(int_arr : int_arr_t) is
	begin
		for i in int_arr'low to int_arr'high loop
			report to_string(int_arr(i));
		end loop;
	end procedure;

-- implement one of the following two procedures
	procedure mergesort(data : inout int_arr_t) is
	begin
	 -- add your implementaion here. Note that you can add further subprograms as you please and we recommend you to do so
	end procedure;

	procedure quicksort(data : inout int_arr_t) is
	begin
	 -- add your implementaion here. Note that you can add further subprograms as you please and we recommend you to do so
		quicksort(data, data'low, data'high);
	end procedure;

	procedure sort(data : inout int_arr_t) is
	begin
		-- uncomment the one you implemented
		-- mergesort(data);
		quicksort(data);
	end procedure;

	procedure draw_array(arr : int_arr_t; nr : inout integer) is
		variable draw : vhdldraw_t;
		constant width : natural := 400;
		constant height : natural := 300;
		variable bar_width : natural := width / arr'length;
		variable baseline : integer := height;
		variable j : integer := 0;
		variable height_multipl : integer := 0;
	begin
		draw.init(width, height);

		if arr(arr'low) < 0 and arr(arr'high) > 0 then
			height_multipl := height / (abs(arr(arr'low)) + abs(arr(arr'high)));
		else 
			height_multipl := height / max(abs(arr(arr'high)), abs(arr(arr'low)));
		end if;
		
		if arr(arr'low) < 0 and arr(arr'high) > 0 then
			baseline := baseline - abs(arr(arr'low)) * height_multipl;
		elsif arr(arr'low) < 0 then
			baseline := 0;
		end if;

		for i in arr'low to arr'high loop
			if arr(i) < 0 then
				draw.setColor(BLUE);
			else
				draw.setColor(RED);
			end if;
			draw.fillRectangle(j * bar_width, baseline, bar_width, -arr(i) * height_multipl);
			draw.setColor(BLACK);
			draw.drawRectangle(j * bar_width, baseline, bar_width, -arr(i) * height_multipl);
			j := j + 1;
		end loop;

		draw.show("sorted" & to_string(nr) & ".ppm");
		nr := nr + 1;
	end procedure;

begin

	main : process is
		variable arr0 : int_arr_t(-10 downto -19) := (10, 9, 8, 7, 6, 5, 4, 3, 2, 1);
		variable arr1 : int_arr_t(-5 to 5) := (-12, 45, 78, -23, 56, 89, 34, 67, 91, -15, -42);
		variable arr2 : int_arr_t(5 downto 0) := (-10, -11, -12, -13, -17, -22);
		variable cnt : natural := 0;
	begin
		sort(arr0);
		print_array(arr0);
		report "###";
		draw_array(arr0, cnt);

		sort(arr1);
		print_array(arr1);
		report "###";
		draw_array(arr1, cnt);
	
		sort(arr2);
		print_array(arr2);
		report "###";
		draw_array(arr2, cnt);

		wait;
	end process;
end architecture;
