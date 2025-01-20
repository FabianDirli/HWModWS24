library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_signal_generator is
	generic (
		COUNTER_WIDTH : integer := 8
	);
	port (
		clk        : in std_ulogic;
		res_n      : in std_ulogic;
		en         : in std_ulogic;
		value      : in std_ulogic_vector(COUNTER_WIDTH-1 downto 0);
		pwm_out    : out std_ulogic
	);
end entity;


architecture arch of pwm_signal_generator is
	signal counter : unsigned(COUNTER_WIDTH-1 downto 0);
	signal gen : boolean := false;
begin
	-- TODO: Implement the PWM generator

	reg : process (clk, res_n) 
  	begin
		if res_n = '0' then
			counter <= (others => '0');
		elsif rising_edge(clk) then
			if gen then
				counter <= counter + 1;
			end if;

			if en = '1' and counter = 0 then
				gen <= true;
			end if;
	
			if counter = 2**COUNTER_WIDTH-1 then
				gen <= false;
			end if;
		end if;
  	end process;

	pwm_gen : process (counter) 
	begin
		if en = '0' and not gen then
			pwm_out <= '0';
		elsif counter < unsigned(value) then
			pwm_out <= '0';
		else 
			pwm_out <= '1';
		end if;

		


	end process;

end architecture;
