
# Watch
**Points:** 2 ` | ` **Keywords:** registers, synthesis, timing analysis

## Task
In this task you will either implement a stopwatch or timer that interacts with the board's I/O in order to be configured and to display information.
For that, implement either the `stopwatch` or the `timer` module (you can of course also implement both) **and** the `bin2dec` module.

### Stopwatch
Write an architecture for the `stopwatch` entity contained in [`stopwatch.vhd](src/stopwatch.vhd) file, having the following interface:

```vhdl
entity stopwatch is
	generic (
		CLK_PERIOD : time;
		DIGITS : integer
	);
	port (
		clk     : in std_ulogic;
		res_n   : in std_ulogic;
		start_n : in std_ulogic;
		stop_n  : in std_ulogic;
		seconds : out unsigned(log2c(10**DIGITS)-1 downto 0)
	);
end entity;
```
The different generics and ports of the `stopwatch` entity have the following meaning

| Name | Description |
|------------|-----------|
| `CLK_PERIOD` | Period of the `clk` signal |
| `DIGITS` | Available decimal digits for printing `seconds` |
| `clk` | clock |
| `res_n` | reset, active-low |
| `start_n` | stopwatch (re)starts on press, active-low |
| `stop_n` | stopwatch stops on press, active-low |
| `seconds` | seconds counted since last press of `start_n` |

The stopwatch starts at zero seconds (applied at `seconds`).
When `start_n` is pressed (you need to detect the appropriate edge for that), the stopwatch shall start to increment `seconds` by one each second, until `stop_n` is pressed.
The stopwatch shall then stop incrementing `seconds` (still providing the value where it stopped at `seconds`).
If `start_n` is pressed while the stopwatch is paused, it shall continue from where it stopped to count (take care to keep the internal values, i.e., if counting stops at 38.870 seconds, make sure that, when resuming, only .130 seconds pass until `seconds` becomes 39).
If `stop_n` is pressed while the stopwatch is paused, the stopwatch shall output 0 seconds and start from scratch the next time `start_n` is pressed.

Note that `seconds` shall **not** overflow, but stop at the highest possible value that can be displayed (this can be computed using `DIGITS`).

### Timer
Write an architecture for the `timer` entity contained in [`timer.vhd](src/timer.vhd) file, having the following interface:

```vhdl
entity timer is
	generic (
		CLK_PERIOD : time;
		DIGITS     : integer
	);
	port (
		clk         : in std_ulogic;
		res_n       : in std_ulogic;
		start_n     : in std_ulogic;
		stop_n      : in std_ulogic;
		seconds_in  : in unsigned(log2c(10**DIGITS)-1 downto 0);
		seconds_out : out unsigned(log2c(10**DIGITS)-1 downto 0)
	);
end entity;
```
The different generics and ports of the `timer` entity have the following meaning

| Name | Description |
|------------|-----------|
| `CLK_PERIOD` | Period of the `clk` signal |
| `DIGITS` | Available decimal digits for printing `seconds` |
| `clk` | clock |
| `res_n` | reset, active-low |
| `start_n` | timer (re)starts on press, active-low |
| `stop_n` | timer stops on press, active-low |
| `seconds_in` | seconds to be counted down by timer |
| `seconds_out` | seconds remaining |

Initially, the timer is continuously providing `seconds_in` at `seconds_out`until `start_n` is pressed (you need to detect the appropriate edge).
Once this happens, the timer internally stores the values applied at `seconds_in`, displaying this value at `seconds_out`.
The timer is now decrementing this stored value once per second, until it reaches zero.
While doing this it always applies the current interal seconds at `seconds_out`.
When `stop_n` is pressed while the timer is counting downwards, the counting is paused (still providing the current value at `seconds_out`).
If `start_n` is pressed while the timer is paused, it shall continue from where it stopped (take care to keep the internal values, i.e., if counting stops at 38.1 seconds, make sure that, when resuming, only .1 seconds pass until `seconds_out` becomes 38).
If `stop_n` is pressed while the timer is paused, the timer shall start outputting `seconds_in` and start from scratch the next time `start_n` is pressed.
Make sure the timer does not underflow! I.e., if it reaches `seconds_out=0`, it shall keep providing zero at `seconds_out` until `stop_n` is pressed again (you can use the "pause mode" for that).

### Binary To Decimal Converter
Independent of the watch module you picked, implement the binary to decimal converter, `bin2dec`, in [`bin2dec.vhd`](src/bin2dec.vhd), having the following interface

```vhdl
entity bin2dec is
	generic(
		SSD_DIGITS : integer
	);
	port(
		clk     : in std_ulogic;
		res_n   : in std_ulogic;
		binary  : in unsigned(log2c(10**SSD_DIGITS)-1 downto 0);
		decimal : out dec_digits_t(SSD_DIGITS-1 downto 0)
	);
end entity;
```

`bin2dec` takes a `binary` input and converts it into an array of decimal digts (`decimal`).
E.g., the binary input `"0110_1100"` (decimal 108) will be converted to an array consisting of elements for the decimal digits 1, 0, 8.
Respective types, also used in the entity port, are provided in [`bin2dec_pkg`](src/bin2dec_pkg.vhd).

Your `bin2dec` module shall compute one decimal digit per clock cycle.
To do this, it initially stores the applied `binary` value.
It then extracts the lowest decimal digital, using a modulo operation, writing it to the respective digit, in each clock cycle.
Furthermore, it also divides the stored value by ten each clock cycle in order to be able to extract the next decimal digit in the next cycle.
After all digits have been extracted and written to `decimal`, the conversion process automatically starts again.
I.e., your module shall continuously convert the applied `binary` input.

### Testbench
Create a testbench for your `stopwatch` / `timer` in [watch_tb](tb/watch_tb.vhd).

For the `stopwatch` your testbench shall apply stimuli such that the simulation waveform shows the stopwatch running into the maximum displayable value for `seconds`.
It shall also show the stopwatch being paused and resumed.

For the `timer`, apply stimuli such that the simulation waveform shows the timer counting down from an applied value to zero.
It shall also show the timer being paused and resumed.


## Synthesis Hardware Test
The final goal of this task is to run your design on a board.
To achieve this, instantiate your `stopwatch`/`timer` and `bin2dec` implementations in [`top_arch.vhd`](top_arch.vhd).
Use `keys(0)` as active-low reset and the other keys for controlling the `stopwatch`/`timer` (for the `timer` you also need the switches).
Show the output of `seconds` / `seconds_out` on `ledr`, as well as on the seven-segment displays (`hex0-7`) using your `bin2dec` implementation.
Use the four right-most ssd displays (set the generics of your modules accordingly), all other ssd display shall be turned off (`SSD_CHAR_OFF` constant).

First try to synthesize your design using the regular 50 MHz board clock, `clk`.
The tools will report that timing requirements are not met, due to a combinational path being too long.
Use the Quartus Timing Analyzer (`Tools->Timing Analyzer`) to display the longest path in a netlist viewer.
To do this, click on `Update Timing Netlist` left in the Timing Analyzer, then scroll down and `Report Top Failing Paths`.
This gives you a list of failing paths.
Right click on the top one and press `Report Worst-Case Path`.
This now gives you a single path.
Right-clicking on it allows you to `Locate Path`.
Make two screenshots, one showing the path in the timing analyzer and one in the netlist viewer.
Put them into this task's directory and make sure they are included in your uploaded submission!

Now, use `clk_20` which is a 20 MHz clock generated by a phase-locked-loop (PLL) (discussed a bit later in the course).
Make sure the `CLK_PERIOD` constant in `top_arch.vhd` is set accordingly.
Synthesize your design again (the timing related warnings should now be gone) and test it on the board.


[Return to main page](../../readme.md)
