
# block RAM
**Points:** 2 ` | ` **Keywords:** memory, synthesis, inferred functions

Your task is to implement a synchronous memory block with the following

```vhdl
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
```

Implement a dual-port RAM (single read, single write) with "write-through" bypass logic directly in VHDL.
This means that your RAM is supposed to output the data on `wr_data` and `rd_data` immediately (i.e., in the same clock cycle) if the read and write address are the same and a write is performed.
You can achieve this by checking whether `wr_addr` and `rd_addr` are equal while `wr_en` is asserted.
Note that this behavior implies that there must be a combinational path from `wr_data` to `rd_data` in your memory.

Additionally, reads on address 0 should always return 0.


**IMPORTANT: Ignore the reset signal (`res_n`) for your first implementation!**

You shall, implement the RAM using memory inference, i.e., do not instantiate any vendor IPs.
To do so, please refer to Section 1.4.1 of the [Intel Quartus Prime User Guide](https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/ug/ug-qpp-design-recommendations.pdf) to learn about inferring RAM functions from HDL Code.
In particular, you should implement a *single-clock synchronous RAM with new data read-during-write behavior*.

## Testbench

Create a testbench for the `simple_dp_ram` entity and place it in the file [`simple_dp_ram_tb.vhd`](tb/simple_dp_ram_tb.vhd).

In your testbench create a clock generation process and connect all required signals to the UUT, setting the generics to`ADDR_WIDTH = 8` and `DATA_WIDTH = 8`.

Your testbench shall read the provided [`debugdata_in.txt`](tb/debugdata_in.txt) file line-by-line, where each line contains an address (decimal), as well as 8-bit of binary data in the format `ADDRESS: BINARY_DATA`.

Extract the decimal address and the 8-bit binary data line-by-line and write the data the given address in your `simple_dp_ram`.

Afterwards, loop over all possible address values and read the respective data from your RAM.
Write the read data if and only if there is valid data at that address (e.g. no 'U' or 'X' vectors) to a file called `debugdata_out.txt`.
Make sure the format is also `ADDRESS: BINARY_DATA`.

You can use the special makefile target `check` to test if your testbench correctly sequentially read the input and that your memory implementation is working correctly.
When everything is working properly, the commands like something like:

```
$make check
[...]
check passed!
```

## Hardware Test

Add an instance of the `simple_dp_ram` entity to the top-level architecture in [`top_arch.vhd`](top_arch.vhd).

Make the following connections and configurations:

- Set `ADDR_WIDTH` to 4
- Set `DATA_WIDTH` to 4
- Connect the top-level `clk` signal to the `clk` input
- Connect `keys(0)` to `res_n`
- Connect `switches(3 downto 0)` to `readaddr` and to `hex0`
- Connect `switches(7 downto 4)` to `writeaddr` and to `hex1`
- Connect `switches(11 downto 8)` to `wr_data` and to `hex2`
- Connect `not keys(3)` to `wr_en` (the keys are active-low, but `wr_en` is not!)
- Display `rd_data` using `hex3`

Use the `to_segs` function to connect the respective signals to the seven-segment displays (`hex0-3`).

Next, synthesize the design with Quartus and download it to the FPGA.
Check if the `simple_dp_ram` is able to store words and to read previously stored ones repeatedly.

Make sure that Quartus successfully inferred a RAM block and that the design is, hence, synthesized correctly (box denoted with `SYNC_RAM`).
To do so open Quartus' RTL viewer and search for your entity, revealing its internals by clicking on it.
You can do this via `Tools->Netlist Viewers->RTL Viewer`.
Make a screenshot of your entity while expanded, such that the RAM blocks are visible and place it in the file `screenshots/1.png`.

## Simple dual-port RAM with Reset

Finally, implement an additional architecture `beh_reset` for your `simple_dp_ram` entity and add reset functionality.
The (active-low) reset should assign 0 to all RAM locations.
Instantiate both `simple_dp_ram` architectures inside your top-level architecture.
Assign the same input signals to the two RAMs, but display the `rd_data` of the second `simple_dp_ram` on `hex4`.
Open Quartus' RTL viewer again and study the difference of both `simple_dp_ram` instances.
Make a screenshot of the `simple_dp_ram` with reset such that you can clearly see the difference between your `simple_dp_ram` with and without reset and place it in the file `screenshots/2.png`.

[Return to main page](../../readme.md)
