library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sram_pkg.all;

entity sram is
	port (
		A : in addr_t;
		IO : inout word_t;
		CE_N : in std_ulogic;
		OE_N : in std_ulogic;
		WE_N : in std_ulogic;
		LB_N : in std_ulogic;
		UB_N : in std_ulogic
	);
end entity;

architecture beh of sram is
	shared variable memory : memory_t(2**20-1 downto 0);
	signal readdata : word_t;
	signal high_z_oe, high_z_ce, high_z_we : boolean := True;
	signal high_z_lb, high_z_ub : boolean := True;

	procedure set_high_z(en : std_ulogic; signal high_z: inout boolean; DELAY_FALL, DELAY_RISE : time) is
	begin
		high_z <= False;
		if en = '0' then
			wait for DELAY_FALL;
			high_z <= False;
		elsif en = '1' then
			wait for DELAY_RISE;
			high_z <= True;
		end if;
	end procedure;
begin

	IO(7 downto 0) <= readdata(7 downto 0) when (not high_z_ce and not high_z_oe and not high_z_lb and high_z_we) else (others => 'Z');
	IO(15 downto 8) <= readdata(15 downto 8) when (not high_z_ce and not high_z_oe and not high_z_ub and high_z_we) else (others => 'Z');

	read : process is
	begin
		wait on A;
		if WE_N = '1' and WE_N'stable(TSA) then
			wait for TAA;
			readdata <= memory(to_integer(unsigned(A)));
		end if;
	end process;

	write : process is
		variable tmp : word_t;
	begin
		wait until falling_edge(WE_N);
		if OE_N = '1' then
			wait for TPWE1-TSD/4;
		else
			wait for TPWE2-TSD/4;
		end if;
		tmp := memory(to_integer(unsigned(A)));
		if LB_N = '0' then
			tmp(7 downto 0) := IO(7 downto 0);
		end if;
		if UB_N = '0' then
			tmp(15 downto 8) := IO(15 downto 8);
		end if;
		memory(to_integer(unsigned(A))) := tmp;
		wait until rising_edge(CE_N) or rising_edge(WE_N) or rising_edge(LB_N) or rising_edge(UB_N); -- according to datasheet any signal can terminate write
	end process;

	oe_z : process is
	begin
		wait until OE_N'event;
		set_high_z(OE_N, high_z_oe, TLZOE, THZOE);
	end process;

	ce_z : process is
	begin
		wait until CE_N'event;
		set_high_z(CE_N, high_z_ce, TLZCE, THZCE);
	end process;

	lb_z : process is
	begin
		wait until LB_N'event;
		set_high_z(LB_N, high_z_lb, TLZB, THZB);
	end process;

	ub_z : process is
	begin
		wait until UB_N'event;
		set_high_z(UB_N, high_z_ub, TLZB, THZB);
	end process;

	we_z : process is
	begin
		wait until WE_N'event;
		set_high_z(WE_N, high_z_we, THZWE, TLZWE);
	end process;
end architecture;
