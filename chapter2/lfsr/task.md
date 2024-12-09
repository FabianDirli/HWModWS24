
# Linear-Feedback Shift Register (LFSR)
**Points:** 2 ` | ` **Keywords:** registers, generics

## Intro
We have already introduced LFSRs lecture.
However, if you want to read more about them be referred to the [Wikipedia article](https://en.wikipedia.org/wiki/Linear-feedback_shift_register)

Important for us is that an LFSR has two important properties:
- The so-called *seed* is the initial value of the shift register
- The so-called *generator polynomial* defines which bits are XOR-ed in the feedback function

To illustrate the above, consider the following example:

![LFSR Example](.mdata/lfsr.svg)

The polynomial is *x⁴+x²+x¹*, because we XOR the fourth, second and first value of the LFSR (counting starts at 1 and from the right).
For our case, such a generator polynomial has purely binary coefficients, i.e. either a power of *x* is part of the polynomial, or it is not.
Thus, we can encode the polynomial using a simple bit-string, where a 1 at index *i* indicates that the polynomial contains *x^i*.
For the example above, this yields the bitstring 1011 for the polynomial and 1100 for the seed.

## Task
Your task is implementing a generic LFSR, writing a testbench for measuring its period and running this on the FPGA board.

### Implementation
Write an architecture for the `lfsr` entity contained [`src/lfsr.vhd`] file, having the following interface:

```vhdl
entity lfsr is
	generic (
		LFSR_WIDTH : integer;
		POLYNOMIAL : std_ulogic_vector
	);
	port (
		clk         : in std_ulogic;
		res_n       : in std_ulogic;
		load_seed_n : in std_ulogic;
		seed        : in std_ulogic_vector(LFSR_WIDTH-1 downto 0);
		prdata      : out std_ulogic
	);
end entity;
```

`clk` and `res_n` are a clock and an active-low reset signal.
The generic `LFSR_WIDTH` defines the width of the LFSR, i.e., the number of flip-flops in the shift register.
`POLYNOMIAL` is the LFSR's generator polynomial.
Consider the example in the above intro to see how this generic encodes a polynomial and how it shall be used.
When `load_seed_n` is low during a clock cycle, the module loads the value applied at `seed` into its internal shift register.
This allows initializing the LFSR.
Whenever `load_seed_n` is high in a clock cycle, `prdata` outputs a new pseudo random bit.

### Testbench
Write a testbench `lfsr_tb` (use the template in [`tb/lfsr_tb.vhd`](tb/lfsr_tb.vhd)) that monitors the output sequence of `prdata`, determining the maximum and minimum period of the output sequence for a particular ``POLYNOMIAL`` and a range of `seed` values.

Your testbench shall attach a shift register to the `prdata` output of the LFSR and wait for sufficiently many clock cycles to let the shift register be completely filled with data from `prdata`.
To measure the period of your LFSR for a seed count the number of clock cycles until you observe this initial value in the shift register again (for a seed of 0 the period is not really meaningful, you can either define it to be 0 or 1).

Your testbench shall do this for a range of seeds automatically during a single run (i.e., you must not enter each seed manually before simulation).
For each checked seed, your testbench should report the seed and the period.
After all seeds got checked, the minimum and maximum period are reported as well.
Hence, a typical simulation output should be similar to the following:

```
seed: [SEED0], period: [PERIOD0]
seed: [SEED1], period: [PERIOD1]
[...]
seed: [SEEDn], period: [PERIODn]
min period: [MIN_PERIOD], max period: [MAX_PERIOD]
```

Below you can find some simulation scenarios (i.e., polynomials and ranges of seeds), allowing you to check your implementation and testbench.

| Polynomial | Start Seed | End Seed | Min Period | Max Period |
|------------|------------|----------|------------|------------|
| MAX_POLY_8 |     1      |   255    |    255     |     255    |
|   POLY_8   |    13      |   125    |     7      |     105    |
|MAX_POLY_16 |    343     |   379    |   65535    |    65535   |
|  POLY_16   |    678     |   750    |    2047    |    63457   |

The first column of the table are refers to constants defined in the testbench.

## Hardware Test
To validate that you described proper hardware, you also have to test your design on the FPGA board.
To do this, use the [top_arch.vhd](top_arch.vhd) file which already contains a top-level architecture that instantiates the `lfsr` module.
Add a process to this architecture, that sets `ledr(0)` (the right-most red LED) to the current `prdata` output whenever `keys(2)` is pressed.
The LED shall retain the set value until the next press of this key, i.e., you need to use a flip-flop.


[Return to main page](../../readme.md)
