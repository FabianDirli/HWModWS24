
<!-- Don't delete anything from this file, just add your answers! Don't change file names! -->

# Hardware Design

<!---------------------------------------------------------------------------->
**Task:** Create an RTL viewer screenshot of the counter entity and save it as `report/design_rtl.png`.

![RTL viewer screenshot of the counter module](design_rtl.png)

<!---------------------------------------------------------------------------->
**Task:** Navigate to the *Compilation Report* in Quartus, select *"Analysis & Synthesis"* -> *"Resource Utilization by Entity"* and save a screenshot of the shown Table as `report/design_rsrc.png`.

![Compilation report Screenshot showing the resource usage of the design](design_rsrc.png)

<!---------------------------------------------------------------------------->
**Question:** Explain why the design uses exactly 88 LUTs and 32 flip-flops in 2-3 sentences.

**Answer:**

[Back to task description](../task.md)

<!---------------------------------------------------------------------------->
**Task:** Extract the instance of the LUT that calculates the LSB of the counter the flip-flop that stores it from the netlist produced by Quartus (`quartus/simulation/questa/top.vho`)

```vhdl
-- Flip-Flop instance representing the LSB of the counter (copy-paste the code snippet from top.vho)
```

```vhdl
-- LUT instance that calculates the LSB of the counter (copy-paste the code snippet from the top.vho)
```

[Back to task description](../task.md)
# Simulation

<!---------------------------------------------------------------------------->
**Task:** Create waveform viewer screenshots showing the first 200 ns after the reset is released for both, the behavioral (`report/sim.png`), and the post-layout (`report/sim_pl.png`), simulations.

![First 200 ns of the behavioral simulation](sim.png)

![First 200 ns of the post-layout simulation](sim_pl.png)


[Back to task description](../task.md)
<!---------------------------------------------------------------------------->
**Task:** Create a waveform viewer screenshot showing the maximum skew value and save it as `report/sim_pl_skew.png`. Be sure to use cursors!

![Maximal skew value](sim_pl_skew.png)

<!--insert your measured skew value here!-->
**Task**: Replace the following by the output of your skew measurement.

```
Measured skew (simulation): XXXX ps for `aux` value 0xXX
```


[Back to task description](../task.md)
# Oscilloscope Measurement

<!---------------------------------------------------------------------------->
**Task**: Measure the skew on the `aux` signal for the case identified in the simulation. Be sure to use cursors! Include a screenshot showing the trigger condition as `report/scope_trigger.png` and one showing the skew measurement with cursors as `report/scope_skew.png`.

![Oscilloscope screenshot showing the trigger condition](scope_trigger.png)

![Oscilloscope screenshot showing the skew measurement with cursors](scope_skew.png)


<!--insert your measured skew value here!-->
**Task**: Measured skew (oscilloscope): XXXX ps

<!---------------------------------------------------------------------------->
**Question**: Why is the skew value measured with the oscilloscope different from the value obtained in the simulation? Provide an explanation in 1-2 sentences!

**Answer**:


