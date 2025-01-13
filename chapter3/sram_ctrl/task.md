
# SRAM Controller

**Points:** 3 `|` **Keywords**: tri-state, datasheet, finite state machine modeling, finite state machine implementation

[[_TOC_]]

Your task is to implement an FSM in [sram_ctrl.vhd](src/sram_ctrl.vhd) that writes to, and reads from, the external [ISSI IS61WV102416](https://www.issi.com/WW/pdf/61WV102416ALL.pdf) SRAM of our FPGA board.
You will then further implement a simple FSM in [sequence_fsm.vhd](src/sequence_fsm.vhd) that stores a sequence of data in this SRAM and reads back in.



## Description

The `sram_ctrl` module has the following interface (the types are declared in [sram_ctrl_pkg.vhd](src/sram_ctrl_pkg.vhd)):


```vhdl
entity sram_ctrl is
	port (
		clk   : in  std_ulogic;
		res_n : in std_ulogic;

		rd       : in std_ulogic;
		wr       : in std_ulogic;
		busy     : out std_ulogic;
		rd_valid : out std_ulogic;

		addr        : in byte_addr_t;
		access_mode : in sram_access_mode_t;
		wr_data     : in uword_t;
		rd_data     : out uword_t;

		-- external interface to SRAM
		sram_dq   : inout word_t;
		sram_addr : out word_addr_t;
		sram_ub_n : out std_logic;
		sram_lb_n : out std_logic;
		sram_we_n : out std_logic;
		sram_ce_n : out std_logic;
		sram_oe_n : out std_logic
	);
end entity;
```


where `clk` is the clock signal, and `res_n` an asynchronous, low-active, reset.
The `sram_*` ports connect directly to the external SRAM.
Their respective meaning can be found in the SRAM's [datasheet](https://www.issi.com/WW/pdf/61WV102416ALL.pdf).
Note that the SRAM data signal, `sram_dq` is of type *inout** since reading **and** writing happens via this signals, requiring you to use **tri-state** logic (i.e., `'0'`, `'1'` and `'Z'`) when driving this signal.
Make sure that signal is never driven by more than one active driver!


The other signals of the `sram_ctrl` provide a simple interface for interacting with the SRAM to other modules.
The following introduces their meaning as well as the general behavior of the `sram_ctrl` FSM:

### Idle Behavior
- The sram_ctrl starts in the idle state.
- When `rd` or `wr` is high for one clock cycle, the FSM samples `addr`, `access_mode`, and `wr_data` (if applicable).
- If both `rd` and `wr` are asserted simultaneously, behavior is undefined.

### Read Operation
- Follows the "read cycle no. 1" from the SRAM datasheet.
- The FSM reads the word stored in the SRAM at the sampled `addr` (converted to a word address).
- The FSM outputs the data it read to `rd_data` and asserts `rd_valid` for **one** clock cycle when the data is valid.
- The read operation must complete in a maximum of **2 clock cycles**.

### Write Operation
- Follows the "write cycle no. 3" from the SRAM datasheet.
- The FSM writes the sampled `wr_data` to the sampled `addr (converted to a word address)`
- The write operation must complete in a maximum of **3 clock cycles**.
- Note that in "write cycle no. 3" `oe_n`and `ce_n` shall be low in the preceding cycle before the actual write.

### Access Mode
- `WORD` mode: In a read operation `rd_data` outputs the entire 16-bit value from the SRAM, in a write operation the whole 16-bit of `wrdata` are written to the SRAM.
- `BYTE` mode: Depending on the byte-address `addr`, the `rd_data` outputs either the lower or upper 8 bits of the SRAM data, while a write operation either writes the lower or upper bits of `wr_data` into the SRAM.

### Miscellaneous

- All outputs to the SRAM shall be registered.
  In particular, this means that all `sram_*` signals shall directly be connected to elements of the state-register (the only exception being `sram_dq` which shall also be set to 'Z' which is not possible via a register).

- While the `sram_ctrl` is performing a memory operation, it shall set `busy` to high.
  No memory operation requests at `rd`, `wr` shall only ever happen while `sram_ctrl` is idle, i.e., while busy is low.

The timing diagram below shows a example operation sequence for the interface provided by `sram_ctrl` in order to guide your FSM design.
It features two read and one write request, where the active clock edges at which the operations start are highlighted by the red lines.


![Example Timing Diagram](.mdata/example_timing.svg)

Also implement an FSM in [sequence_fsm.vhd](src/sequence_fsm.vhd) that stores the `TEST_SEQUENCE` sequence of words from [test_sequence_pkg.vhd](src/test_sequence_pkg.vhd) to the SRAM and then reads it back using the `sram_ctrl` memory interface.
The respective entity has the following interface, allowing to directly connect it to the `sram_ctrl`.



```vhdl
entity sequence_fsm is
	port (
		clk   : in  std_ulogic;
		res_n : in std_ulogic;

		rd       : out std_ulogic;
		wr       : out std_ulogic;
		busy     : in std_ulogic;
		rd_valid : in std_ulogic;

		addr        : out byte_addr_t;
		access_mode : out sram_access_mode_t;
		wr_data     : out uword_t;
		rd_data     : in uword_t
	);
end entity;
```




## Testbench

Implement a testbench in [sram_ctrl_tb.vhd](tb/sram_ctrl_tb.vhd) that validates if your `sram_ctrl` FSM successfully writes to the SRAM and reads from it.
For this purpose you are provided with a very simple model of the SRAM in [sram.vhd](tb/sram.vhd).
Note that your implementation working correctly with this model does not ensure that it also works correctly with the real hardware.
However, do not load your design on the board before it works in simulations with the model!
In addition to the model itself, the [sram_pkg.vhd](tb/sram_pkg.vhd) contains declares constants for the timing values from the SRAM datasheet.


After you are certain that your `sram_ctrl` works, also ensure that your `sequence_fsm` FSM correctly interfaces with your `sram_ctrl`.




## Hardware

Once you have implemented and tested your `sram_ctrl` and `sequence_fsm` implementations, use the provided architecture in [top_arch.vhd](top_arch.vhd) to test your implementation on hardware (do not forget to reset your design!).
The provided code instantiates and connects the `sram_ctrl` and `sequence_fsm`.
Furthermore, it connects `rd_data` to the four right-most seven-segment displays.
If your implementation is correct, they should display `3184`.

Furthermore, use SignalTap to capture the successful read of an arbitrary data word of `TEST_SEQUENCE` (you may pick any of the 16-bit words shown in [test_sequence_pkg.vhd](src/test_sequence_pkg.vhd)).
To do this, add **all** `sram_*` signals to SignalTap and set up a trigger condition comprising the value for `sram_dq` and a read operation.
You can find instructions on how this can be done in the demonstration session recording.
Finally, provide a screenshot showing this, plus a few preceding and succeding SRAM operations, called signaltap.png.



## Deliverables

- **Create**: signaltap.png

- **Implement**: [sram_ctrl.vhd](src/sram_ctrl.vhd)

- **Implement**: [sequence_fsm.vhd](src/sequence_fsm.vhd)

- **Implement**: [sram_ctrl_tb.vhd](tb/sram_ctrl_tb.vhd)
