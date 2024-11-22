library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sram_pkg.all;

entity sram_tb_sample_solution is
end entity;

architecture tb of sram_tb_sample_solution is
	signal A : addr_t;
	signal IO : word_t;
	signal CE_N, OE_N, WE_N, LB_N, UB_N : std_ulogic := '1';
	function max(x, y : time) return time is
	begin
		if x < y then
			return y;
		end if;
		return x;
	end function;
begin

	stimulus : process is
		procedure read1(addr : integer; variable data : out word_t; byteen : byteena_t := "11") is begin
			-- read cycle 1
			-- assume OE_N=CE_N=low/high
			A <= std_ulogic_vector(to_unsigned(addr, A'length));
			LB_N <= not byteen(0);
			UB_N <= not byteen(1);
			wait for TAA;
			-- Do not sample immediately at transition
			wait for (TRC-TAA)/2; -- safe as this is within the window were data is stable
			data := IO;
			wait for (TRC-TAA)/2;
		end procedure;

		procedure read2(addr : integer; variable data : out word_t; byteen : byteena_t := "11") is begin
			A <= std_ulogic_vector(to_unsigned(addr, A'length));
			CE_N <= '0';
			OE_N <= '0';
			LB_N <= not byteen(0);
			UB_N <= not byteen(1);
			wait for TAA;
			-- Do not sample immediately; as long as the inputs are stable we can wait arbitrarily long here -> TRC is just a minimum read cycle time
			wait for 1 ns;
			data := IO;
			LB_N <= '1';
			UB_N <= '1';
			OE_N <= '1';
			CE_N <= '1';
			wait for max(THZOE, THZCE); -- TRC is just a minimal time. With TAA=TRC we already waited for this time. However, the read cycle can take arbitrarily long with only a minimum cycle time given. Hence we wait here for the control signals to take effect.
		end procedure;

		procedure write1(addr : integer; data : word_t; byteen : byteena_t := "11") is begin
			-- write cycle 1
			A <= std_ulogic_vector(to_unsigned(addr, A'length));
			wait for TSA;
			CE_N <= '0';
			WE_N <= '0';
			LB_N <= not byteen(0);
			UB_N <= not byteen(1);
			wait for THZWE;
			IO <= data;
			if OE_N = '1' then
				wait for max(TSCE, TPWE1) - THZWE;
			else
				wait for max(TSCE, TPWE2) - THZWE;
			end if;
			CE_N <= '1';
			WE_N <= '1';
			LB_N <= '1';
			UB_N <= '1';
			wait for THD;
			IO <= (others => 'Z');
			wait for max(max(TLZWE, THZB), THZCE); -- wait for control signals to take effect
		end procedure;

		procedure write2(addr : integer; data : word_t; byteen : byteena_t := "11") is begin
			-- write cycle 2
			-- CE_N assumed to be 0 already
			A <= std_ulogic_vector(to_unsigned(addr, A'length));
			OE_N <= '1';
			wait for TSA;
			WE_N <= '0';
			LB_N <= not byteen(0);
			UB_N <= not byteen(1);
			wait for THZWE;
			IO <= data;
			wait for max(TPWB, TPWE1) - THZWE;
			WE_N <= '1';
			LB_N <= '1';
			UB_N <= '1';
			OE_N <= '0';
			wait for THD;
			IO <= (others => 'Z');
			wait for max(max(TLZWE, THZB), THZOE); -- wait for control signals to take effect
		end procedure;

		procedure write3(addr : integer; data : word_t; byteen : byteena_t := "11") is begin
			-- write cycle 3
			-- CE_N and OE_N assumed to be 0 already
			A <= std_ulogic_vector(to_unsigned(addr, A'length));
			wait for TSA;
			WE_N <= '0';
			LB_N <= not byteen(0);
			UB_N <= not byteen(1);
			wait for THZWE;
			IO <= data;
			wait for max(TPWB, TPWE2) - THZWE;
			WE_N <= '1';
			LB_N <= '1';
			UB_N <= '1';
			wait for THD;
			IO <= (others => 'Z');
			wait for max(TLZWE, THZB); -- wait for control signals to take effect
		end procedure;

		constant testdata : std_ulogic_vector := x"BADC_0DED_C0DE_BA5E";
		variable read_data : std_ulogic_vector(testdata'range);
	begin
		-- Initialization
		A <= (others => '0');
		CE_N <= '1';
		WE_N <= '1';
		OE_N <= '1';
		IO <= (others => 'Z');
		-- This enables reading and writing of both bytes -> you can always keep this low
		LB_N <= '0';
		UB_N <= '0';
		wait for 20 ns;

		-- write 1 for OE_N=0 then read via read cycle 2
		OE_N <= '0';
		CE_N <= '1';
		wait for max(TLZWE, 4 ns); -- the datasheet state for write1 that it was tested with OE_N being set to high at least 4 ns before WE_N is changed -> let's also wait for this time for the OE_N=0 case to be on the safe side, although it might be too high
		-- write to the SRAM using write cycle 1
		for i in 0 to testdata'high/16 loop
			write1(i, testdata(16*i to 16*(i+1)-1));
		end loop;
		-- read cycle 2 expect OE_N=CE_N=1 at its beginning
		OE_N <= '1';
		CE_N <= '1';
		wait for max(THZOE, THZCE); -- wait for control signals to take effect
		-- Run read cycle 2
		for i in 0 to testdata'high/16 loop
			read2(i, read_data(16*i to 16*(i+1)-1));
		end loop;
		report to_hstring(read_data);
		wait for 20 ns;


		-- write 1 for OE_N=1 then read via read cycle 1
		OE_N <= '1';
		CE_N <= '1';
		wait for max(TLZWE, 4 ns); -- the datasheet state for write1 that it was tested with OE_N being set to high at least 4 ns before WE_N is changed -> let's also wait for this time for the OE_N=0 case to be on the safe side, although it might be too high
		-- write to the SRAM using write cycle 1
		for i in 0 to testdata'high/16 loop
			write1(i+16, testdata(16*i to 16*(i+1)-1));
		end loop;
		-- Read cycle 1 assumes OE_N and CE_N to be low
		OE_N <= '0';
		CE_N <= '0';
		wait for max(TLZOE, TLZCE); -- wait for control signals to take effect
		for i in 0 to testdata'high/16 loop
			read1(i+16, read_data(16*i to 16*(i+1)-1));
		end loop;
		report to_hstring(read_data);
		wait for 20 ns;


		-- write to the SRAM using write cycle 2 and read back using read cycle 1
		-- "flush" previously read data to make sure we read it in again instead of just printing the old result
		read_data := (others => '0');
		CE_N <= '0'; -- write cycle 2 assumes CE_N to be low during the whole operation
		OE_N <= '0'; -- write cycle 2 assumes OE_N to be low at the start
		wait for max(THZWE, TLZOE); -- wait for control signal to take effect
		for i in 0 to testdata'high/16 loop
			write2(i+32, testdata(16*i to 16*(i+1)-1));
		end loop;
		-- Read cycle 1 assumes OE_N and CE_N to be low
		OE_N <= '0';
		CE_N <= '0';
		wait for max(TLZOE, TLZCE); -- wait for control signals to take effect
		for i in 0 to testdata'high/16 loop
			read1(i+32, read_data(16*i to 16*(i+1)-1));
		end loop;
		report to_hstring(read_data);
		wait for 20 ns;


		-- write to the SRAM using write cycle 3 and read back using read cycle 1
		read_data := (others => '0');
		-- write cycle 3 assumes CE_N and OE_N to be low
		CE_N <= '0';
		OE_N <= '0';
		wait for max(THZWE, TLZOE); -- wait for control signal to take effect
		for i in 0 to testdata'high/16 loop
			write3(i+48, testdata(16*i to 16*(i+1)-1));
		end loop;
		-- Read, again using read cycle 1
		OE_N <= '0';
		CE_N <= '0';
		wait for max(TLZOE, TLZCE); -- wait for control signals to take effect
		for i in 0 to testdata'high/16 loop
			read1(i+48, read_data(16*i to 16*(i+1)-1));
		end loop;
		report to_hstring(read_data);


		wait;
	end process;

	dut : entity work.sram
	port map(
		A => A,
		IO => IO,
		CE_N => CE_N,
		OE_N => OE_N,
		WE_N => WE_N,
		LB_N => LB_N,
		UB_N => UB_N
	);
end architecture;
