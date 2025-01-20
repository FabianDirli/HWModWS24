library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;

entity running_light is
	generic (
		STEP_TIME  : time := 1 sec
	);
	port (
		clk      : in std_ulogic;
		res_n    : in std_ulogic;
		leds     : out std_ulogic_vector
	);
end entity;

architecture arch of running_light is
	type fsm_state_t is (S0, S1, S2, S3, S4, S5, S6, S7);
	type state_reg_t is record
		state: fsm_state_t;	
		led: std_ulogic_vector(7 downto 0);
		clk_time: time;
	end record;
	signal s, s_next : state_reg_t;
	constant CLK_STEP_TIME : time := 20 ns;
	
	begin

	state_reg : process (clk, res_n)
 	begin
		if res_n = '0' then
			s <= (state => S0, led => "00000001", clk_time => 0 ns);
		elsif rising_edge(clk) then
			s <= s_next;
		end if;
	end process;

	comb : process (all)
	begin
		--default Zuweisungen
		leds <= s.led;
		s_next <= s;

		case s.state is
			when S0 =>
				s_next.led <= "00000001";
				if s.clk_time < STEP_TIME - 20 ns then
					s_next.clk_time <= s.clk_time + CLK_STEP_TIME;
				else 
					s_next.state <= S1;
					s_next.clk_time <= 0 sec;
				end if;
			when S1 =>
				s_next.led <= "00000010";
				if s.clk_time < STEP_TIME - 20 ns then
					s_next.clk_time <= s.clk_time + CLK_STEP_TIME;
				else 
					s_next.state <= S2;
					s_next.clk_time <= 0 sec;
				end if;
		
			when S2 =>
				s_next.led <= "00000100";
				if s.clk_time < STEP_TIME - 20 ns then
					s_next.clk_time <= s.clk_time + CLK_STEP_TIME;
				else 
					s_next.state <= S3;
					s_next.clk_time <= 0 sec;
				end if;
				
			when S3 =>
				s_next.led <= "00001000";
				if s.clk_time < STEP_TIME - 20 ns then
					s_next.clk_time <= s.clk_time + CLK_STEP_TIME;
				else 
					s_next.state <= S4;
					s_next.clk_time <= 0 sec;
				end if;
				
			when S4 =>
				s_next.led <= "00010000";
				if s.clk_time < STEP_TIME - 20 ns then
					s_next.clk_time <= s.clk_time + CLK_STEP_TIME;
				else 
					s_next.state <= S5;
					s_next.clk_time <= 0 sec;
				end if;

			when S5 =>
				s_next.led <= "00100000";
				if s.clk_time < STEP_TIME - 20 ns then
					s_next.clk_time <= s.clk_time + CLK_STEP_TIME;
				else 
					s_next.state <= S6;
					s_next.clk_time <= 0 sec;
				end if;
	
			when S6 =>
				s_next.led <= "01000000";
				if s.clk_time < STEP_TIME - 20 ns then
					s_next.clk_time <= s.clk_time + CLK_STEP_TIME;
				else 
					s_next.state <= S7;
					s_next.clk_time <= 0 sec;
				end if;
				
			when S7 =>
				s_next.led <= "10000000";
				if s.clk_time < STEP_TIME - 20 ns then
					s_next.clk_time <= s.clk_time + CLK_STEP_TIME;
				else 
					s_next.state <= S0;
					s_next.clk_time <= 0 sec;
				end if;
		end case;

	end process;


end architecture;
