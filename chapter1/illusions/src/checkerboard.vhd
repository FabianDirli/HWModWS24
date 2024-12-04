use work.vhdldraw_pkg.all;

entity checkerboard is
end entity;

architecture arch of checkerboard is
begin
	process is
		constant size : natural := 40;
		constant cols : natural := 10;
		constant rows : natural := 11;

		variable vhdldraw : vhdldraw_t;
		variable color : color_t := GREEN;

		-- you might want to add some auxiliary subprograms or constants / variables in here

		variable alt : boolean := true;
	begin
		vhdldraw.init(cols * size, rows * size);

		-- draw the illusion here

		-- draw the blue and green rectangles
		for r in 0 to rows-1 loop
			for c in 0 to cols-1 loop
				if alt = true then
					vhdldraw.setColor(BLUE);
				else 
					vhdldraw.setColor(GREEN);
				end if;

				vhdldraw.fillRectangle(c*size, r*size, size, size);
				alt := not alt;
			end loop;
			alt := not alt;
		end loop;

		--draw the crosses
		alt:= true;

		for r in 1 to rows-1 loop
			for c in 1 to cols-1 loop
				if alt = true then
					vhdldraw.setColor(WHITE);
					vhdldraw.fillRectangle(c*size-size/4, r*size-size/20, size/2, size/10);
					vhdldraw.setColor(BLACK);
					vhdldraw.fillRectangle(c*size-size/20, r*size-size/4, size/10, size/2);
				else 
					vhdldraw.setColor(WHITE);
					vhdldraw.fillRectangle(c*size-size/20, r*size-size/4, size/10, size/2);
					vhdldraw.setColor(BLACK);
					vhdldraw.fillRectangle(c*size-size/4, r*size-size/20, size/2, size/10);
				end if;
				alt := not alt;
			end loop;
		end loop;


		vhdldraw.show("checkerboard.ppm");
		wait;
	end process;

end architecture;
