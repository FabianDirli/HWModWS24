library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simple_dp_ram is
	generic (
		ADDR_WIDTH : positive := 8;
		DATA_WIDTH : positive := 32
	);
	port (
		clk   : in std_ulogic;
		res_n : in std_ulogic;

		rd_addr : in std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
		rd_data : out std_ulogic_vector(DATA_WIDTH - 1 downto 0);

		wr_en   : in std_ulogic;
		wr_addr : in std_ulogic_vector(ADDR_WIDTH - 1 downto 0);
		wr_data : in std_ulogic_vector(DATA_WIDTH - 1 downto 0)
	);
end entity;

architecture arch of simple_dp_ram is
begin
end architecture;
