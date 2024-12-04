library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sram_pkg.all;

entity sram_tb is
end entity;

architecture tb of sram_tb is
	signal A : addr_t;
	signal IO : word_t;
	signal CE_N, OE_N, WE_N, LB_N, UB_N : std_ulogic := '1';
begin

	stimulus : process is
		procedure read(addr : integer; variable data : out word_t) is
		begin
			-- Implement your read procedure that reads from address "addr" and writes the read data into "data"
			OE_N <= '0';
			CE_N <= '0';
			A <= std_ulogic_vector(to_unsigned(addr, A'length));
			wait for TAA;
			wait for 1ns; -- data is NOT valid after TAA!
			data := IO;
			wait for TOHA;
			OE_N <= '1';
			CE_N <= '1';
	
		end procedure;

		procedure write(addr : integer; data : word_t) is
		begin
			-- Implement your write procedure that writes "data" to the address "addr"
			A <= std_ulogic_vector(to_unsigned(addr, A'length));
			wait for TSA;
			CE_N <= '0';
			WE_N <= '0';
			IO <= data;
			wait for THZWE;
			CE_N <= '1';
			WE_N <= '1';
			wait for THD;
			IO <= (others => 'Z');

		end procedure;

		variable read_data : word_t;
		constant testdata : std_ulogic_vector := x"BADC0DEDC0DEBA5E";
		variable retrieved_data : std_logic_vector (0 to 63);
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

		-- write to and read from memory
		write(0, testdata(0 to 15));
		wait for 50 ns;
		write(1, testdata(16 to 31));
		wait for 50 ns;
		write(2, testdata(32 to 47));
		wait for 50 ns;
		write(3, testdata(48 to 63));
		wait for 100 ns;



		read(0, retrieved_data(0 to 15));
		wait for 50 ns;
		read(1, retrieved_data(16 to 31));
		wait for 50 ns;
		read(2, retrieved_data(32 to 47));
		wait for 50 ns;
		read(3, retrieved_data(48 to 63));
		wait for 50 ns;

		report to_hex_string(retrieved_data);

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
