use work.vhdldraw_pkg.all;

entity squarecircle is
end entity;

architecture arch of squarecircle is
begin
	process is
		constant size : natural := 600;
		variable vhdldraw : vhdldraw_t;

		-- you might want to add some auxiliary subprograms or constants / variables in here
	begin
		vhdldraw.init(size);

		-- draw the illusion here

		--draw the rectangles
		vhdldraw.setColor(BLACK);
		vhdldraw.setLineWidth(2);
		for r in 0 to 9 loop
			for c in 0 to 9 loop
				vhdldraw.drawSquare(r * 60 + 5, c * 60 + 5, 50);
			end loop;
		end loop;
		
		--draw the circles
		vhdldraw.setLineWidth(4);
		for r in 1 to 9 loop
			for c in 1 to 9 loop
				vhdldraw.drawCircle(r * 60, c * 60, 30);
			end loop;
		end loop;
		vhdldraw.show("squarecircle.ppm");
		wait;
	end process;

end architecture;
