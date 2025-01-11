library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.math_pkg.all;

entity traffic_light is
	generic (
		WAIT_TIME : integer;
		CLK_FREQ  :  integer
	);
	port (
		clk        : in std_ulogic;
		res_n      : in std_ulogic;
		-- debugging via oscilloscope
		clk_cnt_lb : out std_logic_vector(7 downto 0);
		-- pedestrian traffic light
		btn_n      : in std_ulogic;
		pred       : out std_ulogic;
		pgreen     : out std_ulogic;
		-- car traffic light
		cred       : out std_ulogic;
		cyell      : out std_ulogic;
		cgreen     : out std_ulogic
	);
end entity;

architecture beh of traffic_light is
	type fsm_state_t is (PED_WAIT, CAR_BLINK_OFF, CAR_BLINK_ON, CAR_WARN, PED_GO, CAR_READY);
	type fsm_state_reg_t is record
		state : fsm_state_t;
		old_btn_n : std_ulogic;
		clk_cnt : unsigned(log2c(CLK_FREQ)-1 downto 0);
		sec_cnt : unsigned(log2c(max(WAIT_TIME, 6))-1 downto 0);
	end record;
	constant STATE_REG_NULL : fsm_state_reg_t := (state => PED_WAIT, old_btn_n => '1', others => (others => '0'));
	signal s, s_nxt : fsm_state_reg_t;
begin

	clk_cnt_lb_gen : if s.clk_cnt'high < 7 generate
		clk_cnt_lb(7 downto s.clk_cnt'length) <= (others => '0');
		clk_cnt_lb(s.clk_cnt'length-1 downto 0) <= std_logic_vector(s.clk_cnt);
	else generate
		clk_cnt_lb <= std_logic_vector(s.clk_cnt(7 downto 0));
	end generate;

	sync : process(clk, res_n) is
	begin
		if res_n = '0' then
			s <= STATE_REG_NULL;
		elsif rising_edge(clk) then
			s <= s_nxt;
		end if;
	end process;

	comb : process(all) is
		procedure transition_to_after_wait(nxt_state : fsm_state_t) is
		begin
			if s.clk_cnt = CLK_FREQ-1 and s.sec_cnt < WAIT_TIME-1 then
				s_nxt.clk_cnt <= (others => '0');
				s_nxt.sec_cnt <= s.sec_cnt + 1;
			elsif s.clk_cnt = CLK_FREQ-1 and s.sec_cnt = WAIT_TIME-1 then
				s_nxt.clk_cnt <= (others => '0');
				s_nxt.sec_cnt <= (others => '0');
				s_nxt.state <= nxt_state;
			end if;
		end procedure;
	begin
		s_nxt <= s;
		s_nxt.clk_cnt <= s.clk_cnt + 1;
		pred <= '1'; pgreen <= '0';
		cred <= '0'; cyell <= '0'; cgreen <= '0';

		case s.state is
			when PED_WAIT =>
				s_nxt.clk_cnt <= (others => '0');
				s_nxt.old_btn_n <= btn_n;
				cgreen <= '1';
				if s.old_btn_n = '1' and btn_n = '0' then
					s_nxt.state <= CAR_BLINK_OFF;
				end if;

			when CAR_BLINK_OFF =>
				if s.clk_cnt = CLK_FREQ-1 then
					s_nxt.clk_cnt <= (others => '0');
					s_nxt.sec_cnt <= s.sec_cnt + 1;
					s_nxt.state <= CAR_BLINK_ON;
				end if;

			when CAR_BLINK_ON =>
				cgreen <= '1';
				if s.clk_cnt = CLK_FREQ-1 and s.sec_cnt < 6 then
					s_nxt.clk_cnt <= (others => '0');
					s_nxt.sec_cnt <= s.sec_cnt + 1;
					s_nxt.state <= CAR_BLINK_OFF;
				elsif s.clk_cnt = CLK_FREQ-1 and s.sec_cnt >= 6 then
					s_nxt.clk_cnt <= (others => '0');
					s_nxt.sec_cnt <= (others => '0');
					s_nxt.state <= CAR_WARN;
				end if;

			when CAR_WARN  =>
				cyell <= '1';
				transition_to_after_wait(PED_GO);

			when PED_GO =>
				pred <= '0'; pgreen <= '1';
				cred <= '1';
				transition_to_after_wait(CAR_READY);

			when CAR_READY  =>
				pred <= '1'; pgreen <= '0';
				cyell <= '1';
				if s.clk_cnt = CLK_FREQ-1 and s.sec_cnt = WAIT_TIME-1 then
					s_nxt.old_btn_n <= btn_n;
				end if;
				transition_to_after_wait(PED_WAIT);

		end case;
	end process;

end architecture;
