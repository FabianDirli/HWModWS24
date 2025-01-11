
# PWM Signal Generator

**Points:** 2 `|` **Keywords**: oscilloscope, synthesis, registers

[[_TOC_]]

Your task is to implement a PWM generator in [pwm_signal_generator.vhd](src/pwm_signal_generator.vhd).


## Background

Pulse Width Modulation, for short PWM, refers to a way to control the average voltage of a periodic rectangular signal by changing the signal's *duty cycle*, which is the percentage of a single period in which the signal is high.
The image below illustrates this, more information can be found, e.g., at the ([PWM Wikipedia Entry](https://en.wikipedia.org/wiki/Pulse-width_modulation)).


![PWM Illustration](.mdata/pwm.svg)



## Description

The `pwm_signal_generator` entity has the following interface


```vhdl
entity pwm_signal_generator is
	generic (
		COUNTER_WIDTH : integer := 8
	);
	port (
		clk        : in std_ulogic;
		res_n      : in std_ulogic;
		en         : in std_ulogic;
		value      : in std_ulogic_vector(COUNTER_WIDTH-1 downto 0);
		pwm_out    : out std_ulogic
	);
end entity;
```


where `clk` is the clock signal and `res_n` an asynchronous, low-active, reset signal.
Your implementation shall satisfy the following properties:

- The `pwm_signal_generator` shall contain a `COUNTER_WIDTH`-bits wide internal counter register of type `unsigned`.

- This internal counter register shall be reset to 0.

- Whenever the internal counter is zero, check the enable signal `en`.
  If it is high, the `pwm_signal_generator` shall generate one period of the PWM signal.
  Once the counter starts generating a period, it will complete it independent of `en`.
  Hence, if `en` is asserted while the counter value is zero, the `pwm_signal_generator` should complete a single period and then check `en`again` (during the generation of a period the value of `en`is of no importance).

- During the generation of one period of the PWM signal the internal counter is incremented by one each clock cycle.
  Whenever the internal counter is greater or equal than the value applied at `value`, the `pwm_out`output is set (thus `value` determines the duty cycle).
  Once the internal counter reaches its maximum value (all bits are high), it shall wrap-around to zero, completing one period of the PWM signal.

- Whenever `en` is zero while the `pwm_signal_generator` is not currently generating a period, `pwm_out` must be zero.




## Testbench

Implement a testbench for your design in [pwm_signal_generator_tb.vhd](tb/pwm_signal_generator_tb.vhd).
Set `COUNTER_WIDTH=8`, generate a 1 MHz clock signal and apply it to the `clk` input of `pwm_signal_generator`.
Your testbench shall loop through every possible value for `value` (starting at 1), set up the `pwm_signal_generator` and check if the generated signal is correct.


For that purpose implement the `check_pwm_signal` procedure in the testbench.
This procedure measures the times the generated PWM signal is low/high during a period and assert if this matches the `low_time` / `high_time` arguments.
To get the current simulation time you can use the globally predefined function `now`:



```vhdl
process is
	variable previous : time;
begin
	previous := now;
	wait for 10 ns;
	report to_string(now - previous);
	wait;
end process;
```


Also test if your design reacts correctly to `en` being deasserted while a PWM period is being generated and create a respective screenshot (screenshot.png).




## Hardware

In [top_arch.vhd](top_arch.vhd) you are provided with an instantiation of your design where the right-most button is connected to `res_n`, the left-most switch to `en`, right eight right-most switches to `value` and the PWM generator's output signal to `ledg(0)`.
Therefore, if your implementation is correct, you are able to control the brightness of the right-most green LED.


However, to check if your design is truly correct you are required to measure your PWM signal using an oscilloscope.
[top_arch.vhd](top_arch.vhd) already connects `pwm_out` to the top-right pin of the FPGA board's GPIO connector as illustrated below.


![GPIO Connector](.mdata/gpio_connector.svg)

To conduct the measurement, download your design on a lab computer equipped with an oscilloscope and connect one of its digital inputs to respective pin of the FPGA's GPIO header.
Configure the oscilloscope to trigger on rising edges of the PWM signal and create a screenshot (on the oscilloscope) clearly showing a complete period, featuring vertical markers that measure how long the signal is high during a period.
Copy this screenshot from the oscilloscope, name it oscilloscope.png and submit it together with your implementation.


**Note**: We will show you how to operate our oscilloscopes during the third demonstration session.
Until then, please only use the device if you are either comfortable with operating it, or if a tutor is available to assist you!



## Deliverables

- **Implement**: [pwm_signal_generator.vhd](src/pwm_signal_generator.vhd)

- **Implement**: [pwm_signal_generator_tb.vhd](tb/pwm_signal_generator_tb.vhd)

- **Create**: oscilloscope.png

- **Create**: screenshot.png
