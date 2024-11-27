
# Generic Adder
**Points:** 1 ` | ` **Keywords:** structural modeling, generics, generates

Your task is to create a generic N-bit adder with the following interface (defined in [`generic_adder`](src/generic_adder.vhd)):

```vhdl
entity generic_adder is
	generic (
		N : positive := 4
	);
	port (
		A    : in std_ulogic_vector(N-1 downto 0);
		B    : in std_ulogic_vector(N-1 downto 0);

		S    : out std_ulogic_vector(N-1 downto 0);
		Cout : out std_ulogic
	);
end entity;
```

The `generic_adder` must be implemented by chaining together multiple 4-bit adders.
If you completed the `structual_adder` task from Chapter I, you should already know the `adder4` module.
In any case, here is its interface:

```vhdl
entity adder4 is
	port (
		A : in std_ulogic_vector(3 downto 0);
		B : in std_ulogic_vector(3 downto 0);
		Cin : in std_ulogic;

		S  : out std_ulogic_vector(3 downto 0);
		Cout  : out std_ulogic
	);
end entity;
```

For this task we already provide you with a working version of the `adder4` module in [`adder4.vhd`](src/adder4.vhd).
Hence, **don't** use your solution from Chapter I.

Besides its `port` section, the `generic_adder` component also contains a `generic` section, where it defines the generic `N` which determines the bit width of the adder.
Since you are supposed to chain 4-bit adders you have to make sure that the bit width `N` is divisible by 4 at compile-time using assertions in the entity's statement part.

# Testbench

Implement a testbench for your `generic_adder` named [`generic_adder_tb`](tb/generic_adder_tb.vhd).

```vhdl
entity generic_adder_tb is
	generic (
		TESTMODE : string := "exhaustive"
	);
end entity;
```

As you can see from the testbench's entity declaration, it features the generic `TESTMODE`, which controls the test scenario that should be executed.
The two possible values `TESTMODE` can have are `exhaustive` and `fibonacci`.

- `exhaustive`: Instantiate an 8-bit adder and create a stimulus process that exhaustively tests whether it correctly calculates all possible A * B possible additions.
Do not forget to also check the correct value of the `Cout` signal.

- `fibonacci`: Instantiate a 32-bit adder and use it to calculate the [fibonacci sequence](https://en.wikipedia.org/wiki/Fibonacci_sequence) starting by adding 0 and 1.
Stop when the carry out bit is high and report the last calculated number as well as the number of steps it took to get there.

For any other value the testbench shall raise a compile error.
Use a generate statement to implement the testbench.

To make it convenient for you to run the testbench with either of the two possible values, the provided makefile provide additional targets:

```bash
make [g]sim[_gui]_{exhaustive,fibonacci}
```

For example, to run the testbench in `fibonacci` mode using GHDL you can run `make gsim_fibonacci`.


# Hardware Test

Integrate your entity into the top-level design ([`top_arch.vhd`](src/top_arch.vhd)).
Think of a way to connect your circuit to the FPGA's peripherals, in order to test its functionality.
Compile the design with Quartus and download it to the FPGA.



[Return to main page](../../readme.md)
