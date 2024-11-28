
# Sorting Network
**Points:** 1 ` | ` **Keywords:** registers, unconstrained types

In this task you will design a sorting network to sort 4 inputs in hardware.
Start by making yourself familiar with the concepts of [sorting networks](https://en.wikipedia.org/wiki/Sorting_network).

## Task

Your task is to implement a sorting network for 4 inputs (`N4`) using 5 compare/exchange elements (CE, `L5`) and 3 layers ('D3') (the network is thus called `N4L5D3`).
For reference, check out [this list](https://bertdobbelaere.github.io/sorting_networks.html) about *Smallest and fastest sorting networks for a given number of inputs*.

The circuit shall be implemented in the `sorting_network` module, which has the following interface:

```vhdl
component sorting_network is
	generic (
		DATA_WIDTH : natural := 32
	);
	port (
		clk      : in std_ulogic;
		res_n    : in std_ulogic;

		unsorted_data : in  std_ulogic_vector;
		sorted_data   : out std_ulogic_vector;

		start : in std_ulogic;
		done  : out std_ulogic
	);
end component;
```

The generic `DATA_WIDTH` refers to the width of a single data input.
`clk` and `res_n` are a clock, respectively an active-low reset signal.
The two I/O vector signals are for unsorted, respectively sorted, data.
The total size of these vectors shall hold four data words.

The signal `start` signals your design to start sorting the inputs.
Lastly, `done` is supposed to be asserted for one clock cycle whenever your design finished sorting its input and the sorted data is output on `sorted_data`.

Place registers between all layers of your sorting network, as well as at the input and output of the sorting network.
I.e., for `N4L5D3` in the first clock cycle after sampling a high `start` and the input data, it first compares inputs 0 & 2 and 1 & 3 simultaneously.
The intermediate registers then sample the result of this first layer.
The output of these registers is then used by the next sorting network layer, which is then stored by further registers and so on.
The sorting should thus not take more than five clock cycles.


Make sure your design is able to handle arbitrary `DATA_WIDTH` sizes, sorting four inputs of `DATA_WIDTH` contained in the `(un)sorted_data` I/O vectors.
Since the unsorted and sorted data vectors are unconstrained, your entity for the `sorting_network` component has to make sure that the length of its `sorted` and `unsorted` data vectors are the same and that their length is four times `DATA_WIDTH`.
You must **not** make these checks in an architecture but in the entity (recall the `entity_statement_part` in the entities and architectures lecture).

## Testbench

Implement the testbench ([sorting_network_tb.vhd](./tb/sorting_network_tb.vhd)) to test your `sorting_network` entity.
Make sure your design is able to successfully sort its input.

Test your entity to sort the same input digits but with different `DATA_WIDTH` sizes (e.g. 8 and 16-bit per digit).

## Hardware

Instantiate your design in the provided `top_arch.vhd` file and set `DATA_WIDTH` to 4.

Assign the `clk` signal and assign `res_n` to `keys(0)`.

Use the switches `switches(15 downto 0)` for your inputs, using four switches for one input value.
Display your switches input (`unsorted_array`) on the seven segment displays `hex7,hex6,hex5,hex4` and assign the button `keys(3)` to the `sorting_network`'s `start` signal.

Lastly, show your design's `sorted_array` output `hex3,hex2,hex1,hex0`.

**Hint**: Use the `to_segs` function of the [util package](../../lib/util/doc.md) to display a 4-bit decimal digit.



[Return to main page](../../readme.md)
