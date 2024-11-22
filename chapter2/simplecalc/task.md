
# Simple Calculator
**Points:** 2 ` | ` **Keywords:** registers, arithmetic operations

Your task is to implement a simple calculator with the following interface:

```vhdl
entity simplecalc is
	generic (
		DATA_WIDTH : natural := 8
	);
	port(
		clk    : in std_ulogic;
		res_n  : in std_ulogic;

		operand_data_in : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
		store_operand1  : in std_ulogic;
		store_operand2  : in std_ulogic;

		sub : in std_ulogic;

		operand1 : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
		operand2 : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
		result   : out std_ulogic_vector(DATA_WIDTH-1 downto 0)
	);
end entity;
```

The calculator has two internal registers named `operand1` and `operand2`, which can be read via the corresponding outputs of the entity.
Those registers are reset to zero using the asynchronous, active-low, reset `res_n`.
The calculator constantly outputs the sum (`sub`=0) or the difference (`sub`=1) of these two operands at the `result` output.

New data is loaded into the operand registers when falling transitions are applied to the `store_operand1` or `store_operand2` inputs.
Whenevern the calculator detects a falling transition on `store_operand1` it stores the current value at `in_data` to the `operand1` register.
Likewise, with a falling transition on `store_operand2`, `in_data` is written to `operand2`.

The inputs `store_operand1` and `store_operand2` are intended to be connected to (active-low) buttons (consult the [FPGA board manual](https://www.terasic.com.tw/cgi-bin/page/archive_download.pl?Language=English&No=502&FID=cd9c7c1feaa2467c58c9aa4cc02131af) to read about our board's buttons).
A falling input transition would, hence, correspond to a button press.
A button press can be detected by observing a signal change from `1` to `0` between two clock cycles.
Hence, you will need flip-flops to remember the last button states.
Be sure to also correctly initialize those flip-flops during reset.
**Important**: As they aren't clock signals, do not use `falling_edge` or `rising_edge` on `store_operand1` or `store_operand2` to detect button presses!


## Testbench

Create a testbench for the `simplecalc` entity and place it in [`simplecalc_tb.vhd`](tb/simplecalc_tb.vhd).
Let the circuit register a few different input values and check the output `result` for correctness using assertions.
Your testbench shall perform at least **four** different calculations.

## Hardware Test

Add an instance of the `simplecalc` entity to the top-level architecture in [`top_arch.vhd`](top_arch.vhd).

- Connect the clock signal to `clk`
- Connect `keys(0)` to `res_n`
- Connect `switches(7 downto 0)` to `input_data`
- Connect `switches(17)` to `sub`
- Connect `keys(1)` to `store_operand1`
- Connect `keys(2)` to `store_operand2`
- Display `operand1` as a hexadecimal number on `hex7` and `hex6`, i.e., use the `to_segs` function of the [util package](../../lib/util/doc.md) to display the 4 upper bits of `operand1` on `hex7` and the 4 lower bits on `hex6`
- Display `operand2` as a hexadecimal number on `hex5` and `hex4`
- Display `result` as a hexadecimal number on `hex3` and `hex2`

Compile the design with Quartus and download it to the FPGA.
Ensure that the calculator works as intended in hardware.
Take special care that your design does not contain latches or combinational loops!



[Return to main page](../../readme.md)
