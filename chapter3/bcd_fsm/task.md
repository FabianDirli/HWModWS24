
# BCD FSM

**Points:** 2 `|` **Keywords**: fsm modeling, fsm implementation

[[_TOC_]]

Your task is to model and implement a synchronous FSM for converting a binary number to a [Binary Coded Decimal](https://en.wikipedia.org/wiki/Binary-coded_decimal) and displaying it on the board's seven-segment displays (SSD).


## Description

The `bcd_fsm` entity has the following interface


```vhdl
entity bcd_fsm is
	port(
		clk         : in std_ulogic;
		res_n       : in std_ulogic;

		input_data  : in std_ulogic_vector(15 downto 0);
		signed_mode : in std_ulogic;

		hex_digit1     : out std_ulogic_vector(6 downto 0);
		hex_digit10    : out std_ulogic_vector(6 downto 0);
		hex_digit100   : out std_ulogic_vector(6 downto 0);
		hex_digit1000  : out std_ulogic_vector(6 downto 0);
		hex_sign       : out std_ulogic_vector(6 downto 0)
	);
end entity;
```


where `clk` is the clock signal and `res_n` an asynchronous, low-active, reset signal.
Model the synchronous `bcd_fsm` FSM and upload a drawing of it named fsm_model.png.
Then, implement your model in [bcd_fsm.vhd](src/bcd_fsm.vhd).
The FSM shall implement the following functionality:

- The FSM shall sample the 16-bit binary input number provided at `input_data` whenever either `input_data` or `signed_mode` changes, also starting the conversion process.

- For the conversion to a BCD the FSM **must not** use a division operation, but rather successively subtract decimal powers from the sampled value until it becomes zero.
  This will effectively convert the sampled value into a [BCD](https://en.wikipedia.org/wiki/Binary-coded_decimal).
  I.e., start by subtracting 1000 from the sampled number and counting the subtraction steps until the number becomes smaller than 1000.
  This gives you the thousands digit, continuing in this manner provides you with the hundreds, tens and ones digits as well.

- During the conversion your FSM shall perform one of these subtractions per clock cycle.

- After a conversion the FSM shall provide the resulting BCD via the `hex_digit1000`, `hex_digit100`, `hex_digit10` and `hex_digit1` outputs as seven-segment signals (you can use the `to_segs` function in [util_pkg.vhd](../../lib/util/src/util_pkg.vhd) for that) until the next conversion starts.
  E.g., an unsigned conversion of the 16-bit number 0x0ABC (decimal 2748) shall result in the SSD digits 2, 7, 4, and 8 being provided at the `hex_digit*` outputs.

- If the input number exceeds the range that can be displayed by four decimal digits, output " OFL" or "- OFL" for unsigned and signed modes respectively.

- If `signed_mode` is asserted, the number sampled from `input_data` shall be interpreted as **signed** integer in [Two's Complement](https://en.wikipedia.org/wiki/Two%27s_complement) and otherwise as unsigned.
  In the case of a signed conversion, the FSM shall check if the sampled input number is smaller than 0.
  If that's the case, it must be converted to a positive number before the conversion

- The FSM shall output `SSD_CHAR_DASH` on `hex_sign` for negative numbers.
  Otherwise, this output shall be set to the `SSD_CHAR_OFF` constant.

- Your FSM may output leading zeros for converted numbers (i.e., rather than providing "  13" to the `hex_digit*` outputs, the FSM can output "0013").




## Testbench

Implement a testbench for your design in [bcd_fsm_tb.vhd](tb/bcd_fsm_tb.vhd).
Include at least 16 test cases: 8 for signed mode and 8 for unsigned mode.
Ensure to also cover edge cases (e.g., maximum, minimum, zero, overflow).
Note that you are provided with a Questasim configuration file in [wave.do](wave.do) that sets up the waveform viewer to show all ports of the DUT and to display the `hex_*` signals correctly as SSD digits.




## Hardware

In [top_arch.vhd](top_arch.vhd) you are provided with an instantiation of your design where the right-most button is connected to `res_n`.
The 16 right-most switches are connected to `input_data`.
The `signed_mode` input is connected to the left-most switch.
The `hex_*` outputs are connected to the five right-most hex displays in the obvious order.


Make sure that your design works in **both**, the signed and unsigned, modes and that it also correctly displays input overflows.


## Deliverables

- **Implement**: [bcd_fsm.vhd](src/bcd_fsm.vhd)

- **Implement**: [bcd_fsm_tb.vhd](tb/bcd_fsm_tb.vhd)

- **Create**: fsm_model.png
