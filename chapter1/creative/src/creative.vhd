use work.vhdldraw_pkg.all;

entity creative is
end entity;

architecture arch of creative is
begin
	main : process is
		variable draw : vhdldraw_t;

		constant a0 : integer := 10;  -- Startwert
		constant r : real := 1.5;      -- Verhältnisfaktor
		constant num_terms : integer := 10; -- Anzahl der Terme
		constant frame_width : natural := 800;
		constant frame_height : natural := 600;

		-- Zeichnen der geometrischen Reihe
        variable x_pos : integer := 100;  -- Startposition
        variable y_pos : integer := frame_height - 100;  -- Y-Position

		variable height : integer := integer(a0 * (r ** real(n)));
	begin
		-- change the dimensions to anything you want
		--draw.init(400, 400);
		--draw.show("creative.ppm");

		-- Initialisierung des Zeichenrahmens
        draw.init(frame_width, frame_height);
        draw.clear(WHITE);  -- Hintergrundfarbe weiß

        

        for n in 0 to num_terms - 1 loop
            -- Berechnung der Höhe des Rechtecks basierend auf der geometrischen Reihe
            

            -- Zeichnen des Rechtecks
            draw.fillRectangle(x_pos, y_pos - height, 50, height);
            
            -- Position für das nächste Rechteck anpassen
            x_pos := x_pos + 60;  -- Abstand zwischen den Rechtecken
        end loop;

        -- Anzeige des Zeichens
        draw.show("geometric_series.ppm");

		wait;
	end process;
end architecture;
