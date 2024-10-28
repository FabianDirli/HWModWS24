library ieee;
use ieee.std_logic_1164.all;
use work.adder4_pkg.all;

entity or_gate is
	port (
		A : in std_ulogic;
		B : in std_ulogic;

		Z : out std_ulogic
	);
end entity;

architecture or_gate_arch of or_gate is
begin
	Z <= A or B;
end architecture;
