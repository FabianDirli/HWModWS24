
# Project Setup
**Points:** 1 ` | ` **Keywords:** quartus, synthesis

[[_TOC_]]

# Introduction
The aim of this task is to introduce you to the design flow used in HWMod and to show you how you can create a Quartus project, and which tools Quartus provides you with.
We recommend you to complete this task before any other task, as helpful tools and commands will be covered.

The tool flow is intended to work on the TILab computers and the provided VM.
Please note that we **cannot** support custom setups, even if you install the same tool version (the VM uses Quartus 22.1).
If you run a custom installation, make sure that everything also works in the lab (or the VM)!

All screenshots you see in this document, were created using the VM.


# Logic Synthesis and Place&Route

As introduced in the second demonstration session, we are going to use the [DE2-115](https://www.terasic.com.tw/cgi-bin/page/archive.pl?CategoryNo=&No=502) development board from [Terasic](https://www.terasic.com.tw/), shown in the Figure below.

![The DE2-115 Development Board with Intel Cyclone IV FPGA](.mdata/de2-115.svg)

It features an Intel Cyclone IV FPGA.
Originally this FPGA was developed by Altera, which has been bought by Intel in 2015.
So you might see this former name pop up in documentation or manuals from time to time.

Besides the actual FPGA, the board also features a lot of peripheral devices and ports.
These range from simple components, like LEDs, [seven-segment displays](https://en.wikipedia.org/wiki/Seven-segment_display), switches and buttons, to more advanced ICs that implement various types of memories or [DACs](https://en.wikipedia.org/wiki/Digital-to-analog_converter) to generate analog output signals (e.g., VGA).
However, during this course we will mostly interface with the simple peripheral components.

The EDA software needed for compiling hardware designs (i.e., VHDL code) for Intel FPGAs is called [Quartus Prime](https://www.intel.com/content/www/us/en/products/details/fpga/development-tools/quartus-prime.html).
This chapter will guide you through the process of creating a project, that you will use throughout this course.

To start Quartus, run the following command in a terminal (or use an application menu entry if available):

```bash
quartus --64bit &
```

After startup Quartus should roughly look like the window shown in the following screenshot:

![Quartus Prime main window (no project loaded)](.mdata/quartus_initial.png)

## Quartus Project Creation
To create a new project click on `File->New Project Wizard`, which should result in the following dialog being shown:

![New Project Wizard (Step 1)](.mdata/quartus_npw_1.png)

Click `Next`.

![New Project Wizard (Step 2)](.mdata/quartus_npw_2_path.png)

In this step, you have to configure the directory where the project is stored.
Set it to the `quartus` directory of this task.
The name of the project must be set to `top`.
For top-level entity `dbg_top` must be selected.
This is the name of a wrapper which we will use to provide you with additional functionality required for the remote lab and will be discussed further below.

Click `Next`, select `Empty project` in the next step and click `Next` again.

![New Project Wizard (Step 4)](.mdata/quartus_npw_4_files.png)

In this step source files can be added to the project.
For this task you need to add some source files of the `lib` directory, i.e.

* `lib/top/src/dbg_core.qxp`
* `lib/top/src/dbg_top.vhd`
* `lib/top/src/top.vhd`
* `lib/util/src/util_pkg.vhd`

The `.qxp` file contains a macro block of the already synthesized, placed and routed ``dbg_core`.

Additionally, add the following two files of the task directory

 * `top_arch.vhd`
 * `src/demo.vhd`

**Note**: This is of no relevance for this task, but never add any simulation files to Quartus as they might not be synthesizable.

Click `Next`.

![New Project Wizard (Step 5)](.mdata/quartus_npw_5_device.png)

Now the actual FPGA device must be configured.
Make sure that `Family` select box is set to `Cyclone IV E`.
Choose `EP4CE115F29C7` from the list of available devices.
You can make use of the `Name Filter` text box on the right to limit the number of shown available devices.

Click `Next`.

![New Project Wizard (Step 5)](.mdata/quartus_npw_6_tools.png)

Here, you can leave the default settings, i.e., `<None>`.
Click `Next` and `Finish`.
If a prompt asks if you trust the source, click `Yes`.
You now have an empty Quartus project to apply the following steps on.

If a prompt asks if you trust the source, click `Yes`.
You now have an empty Quartus project to apply the following steps on.

**Hint:**
Quartus project files are text-based (actually they constitute TCL scripts).
Hence, if you feel comfortable with it, you can simply edit them in any text editor, to e.g., add new files to the project.
If you are interested in how such files look like, feel free to skim the `.qsf` files in the `quartus` directory.
Be sure to only do this while the Quartus GUI is **not** running though!

## Compiler Settings

With the project being created, you can make some adjustments to the compiler settings.
Open the project setting dialog under `Assignments -> Settings` and go to the `Compiler Settings` in the list on the left side of the window.
Here you can select the optimization mode and change various other fine-grained synthesis and fitter settings.

![Quartus Compiler Settings Dialog](.mdata/quartus_compiler_settings.png)

The VHDL version that is used for the Quartus project can be configured in the "VHDL input" sub-menu on the left.
Be sure to set it to **VHDL 2008**, otherwise the source files will not compile.

![Quartus VHDL Input Dialog](.mdata/quartus_vhdl_input.png)

## Timing Constraints

Quartus needs to be informed about certain timing parameters and constraints.
The most important one is, arguably, the information about which signals are clocks and at what frequencies they operate.
The timing analyzer can then determine whether the compiled design reaches the performance goals (in terms of achievable maximum frequency) or not.

In Quartus (and also other EDA tools) this is done using a "Synopsys Design Constraints File" or `*.sdc` file.
Hence, create a file named `top.sdc` and place it in the `quartus` project directory.
Add the file to your project using the `Project -> Add/Remove Files in Project` menu entry and add the following lines to it.

```tcl
# Clock constraints
create_clock -name "clk" -period 20.000ns [get_ports {clk}]

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty
```

This minimal constraints file specifies that the `clk` input of our design is supplied with a 50 MHz clock signal.

## Top-Level Entity

The top-level entity selected during the project creation defines the interface of the design to the "outside world".
In our case the top level entity is `dbg_top`.
This module implements a wrapper around the actual top-level entity, which is simply called `top`.
This wrapper contains the `dbg_core`, which allows us to control the design in the Remote Lab.
This is necessary, as it is not possible to physically interact with the board (e.g., press buttons, flip switches) or its peripherals in the Remote Lab.
Using the `dbg_core` peripheral components of the `top` entity can be emulated via a UART interface from a lab computer to an attached board.

Usually, every task comes with its own top-level architecture, located in the respective task directory, named `top_arch.vhd`, that declares the task architecture for this `top` entity.

In this task we are using the `top_arch` architecture, located in the file `top_arch.vhd`:

```vhdl

use work.util_pkg.all;

architecture top_arch of top is
begin
	demo : entity work.demo
	port map (
		a => switches(0),
		b => switches(1),
		x => ledg(0)
	);

	ledr <= switches;
	ledg(8 downto 1) <= (others=>'0');

	hex7 <= to_segs(x"2");
	hex6 <= to_segs(x"0");
	hex5 <= to_segs(x"2");
	hex4 <= to_segs(x"4");
	hex3 <= to_segs(switches(15 downto 12));
	hex2 <= to_segs(switches(11 downto 8));
	hex1 <= to_segs(switches(7 downto 4));
	hex0 <= to_segs(switches(3 downto 0));

end architecture;

```

As you can see this architecture simply instantiates the `demo` entity and connects its inputs to switches.
The output is connected to one of the green LEDs.
Furthermore, it connects the switches to the red LEDs.
Hence, in this design, each red LED can be switched on/off by the switch directly located under it on the board.
Furthermore, the left-most four seven-segment display are connected to constant values, whereas the four right-most ones are each showing the hexadecimal value selected by four consecutive switches.

Note that the `dbg_top` design also takes care of synchronizing the `keys` and `switches` inputs to the clock domain of the 50 MHz `clk` signal.
This is necessary, because asynchronous inputs can cause [metastability](https://en.wikipedia.org/wiki/Metastability_(electronics)) in digital circuits.
For you this means that you can always safely use these inputs in your top-level design without the need for a synchronizer.
However, do not worry about this little remark too much.
We will discuss (asynchronous) external inputs and metastability thoroughly in a future lecture.

## Pinout

Now you have to add constraints to your project, such that each interface signal of the top-level entity is mapped to the right physical I/O Pin of the FPGA.
However, before you can do that, you have to run the `Analysis and Elaboration` compilation sub-step.
During this process, Quartus reads all source files and gathers the necessary information about the top-level interface.
To do that select `Processing -> Start -> Start Analysis and Elaboration`.

When complete run `Assignments -> Pin Planner` to open the pin assignment editor.

![Pin Planner without any pin assignments](.mdata/pp_no_assignments.png)

The lower part of this window shows a list of all signal of the top-level entity.
Notice, that for none of them a location is set.

The information, which external signal is connected to which pin of the FPGA, can be found in the [Manual](https://www.terasic.com.tw/cgi-bin/page/archive_download.pl?Language=English&No=502&FID=cd9c7c1feaa2467c58c9aa4cc02131af) of the FPGA Board.
However, to save you some time, we already provide you with most of the pin mappings.
To import them close the Pin Planner and select `Assignments -> Import Assignments`.

![Import Assignments Window](.mdata/import_assignments.png)

Select the file `de2-115_pinout.qsf` of the `project_setup` task directory and click `OK`.
Afterwards open the Pin Planner again.

![Pin Planner after the import of the pinout](.mdata/pp.png)

Now everything, except for the 50 MHz input clock signal `clk` and the output `ledg(0)`, is connected to a pin.
Consult the [FPGA board manual](https://www.terasic.com.tw/cgi-bin/page/archive_download.pl?Language=English&No=502&FID=cd9c7c1feaa2467c58c9aa4cc02131af) to find out their locations (the pins are called `CLOCK_50` and `LEDG[0]` in the manual) and assign them using the Pin Planner.

**Be sure to select the correct I/O Standard!**
The default value in the Pin Planner is not correct for one of the pins.

## Compilation

With the project fully set up you can now start the actual process of synthesizing, placing and routing our design.
To initiate this process, use the `Processing -> Start Compilation` menu entry.
The individual steps can be also be started using the `Tasks` panel on the left-hand side of the main window.

During the different steps Quartus might output warnings and errors in the `Messages` panel, placed at the bottom of the main window.
The compilation was successful if it finished without any error messages.
The warnings are less critical and can provide you valuable feedback about your design, highlighting possible issues.
However, sometimes the warnings can be ignored as the reported issues do not relate to the code you wrote (but rather to the cores we provide you with), or are of no concern for the particular exercise.

To support you in focusing at the tasks at hand, we already filter out some of the warnings that do not originate from your design in the other tasks.
However, some warnings are not filtered out as they might indicate a problem with your design (but do not have to).
See the [list](#allowed-quartus-warnings) of allowed warnings to determine which of the messages can be ignored safely - however, be ready to reason why you chose to ignore them, we will ask you during the exercise session.
If you followed the given steps in this task, you ignore all warnings.
However, you still should skim through them and think about what they mean.

Finally, the result of the compilation is the bitstream (`*.sof`) file, which can now be loaded onto the FPGA.
It is located in the `quartus/output_files` directory.


### Makefile

You can also start the compilation process from the command line using the Makefile provided in the task directory (all tasks come with such a Makefile).
Simply run

```bash
make qcompile
```

to start the process.
You can also use the `qgui` target to launch Quartus from the command line, automatically loading the project and then create the bitstream there.

### Netlist Viewers

Quartus provides powerful tools to view and analyze the compiled design.
You can start them using the menu items in `Tools -> Netlist Viewers`.
The different viewers show the design at the different stages throughout the compilation process.

The screenshot below shows the `demo` module using the RTL Viewer.

![Quartus RTL Viewer](.mdata/rtl_viewer.png)

### Chip Planner

Using the Chip Planner (`Tools -> Chip Planner`), you can see how your design is placed inside the FPGA.
It is even possible to make adjustments here or to derive placements constraints.
However, this goes beyond the scope of this course.
Nevertheless, it can be interesting to check it out.

# Download and Test
After a successful compilation of your design, it is time to download the generated bitstream to the FPGA in order to try it out in hardware.

Depending on whether you work locally in the TILab, or remotely using the Remote Lab, the process to do so differs slightly, also see [Remote Lab](#remote-lab).

## Local in the TILab

The Makefile provides the `qdownload` target.
This target takes the generated bitstream file and downloads it to the FPGA board using its JTAG interface.

```bash
make qdownload
```

The programming procedure can also be started form the Quartus GUI via the Programmer window (`Tools -> Programmer` or the corresponding button in the toolbar).
The screenshot below shows how this window looks like:

![Quartus Programmer](.mdata/programmer.png)

Typically, all settings should be correct and the FPGA board will be detected automatically.
However, if the textbox in the upper-left corner displays the message `No Hardware`, you have to click on the `Hardware Setup` button and connect the board manually.
Make sure `Program/Configure` is checked before you hit the `Start` button to begin programming.

Note that the bitstream is stored in the configuration SRAM of the FPGA, which is volatile memory.
This means that if the board is disconnected from power (i.e., switched off), the configuration data is lost and the FPGA "boots up" with a default design (with a lot of blinking LEDs).
Therefore, after each restart of the board you have to upload design again.

No matter if you use the Makefile target or the GUI, programming should not take more than a few seconds.

**Caution:** There is a bug in the JTAG server, which can sometimes cause the programmer to fail or freeze.
In such a case perform the following routine:

 * Switch off the FPGA board (if possible)
 * Open a terminal and execute

```bash
killall jtagd
jtagconfig
```

 * Now switch the board on again. Then execute the command `jtagconfig`. The board should now be detected and you should get an output similar to:

```
1) USB-Blaster [1-3]
  020F70DD   10CL120(Y|Z)/EP3C120/..
```

 * If the command `jtagconfig` does not terminate within two seconds, repeat the whole process. Should you get an error referring to missing permissions, you have to reboot the machine.


**Important**:
Please make sure to always log out when you leave the lab! The missing permissions error mentioned above is caused by multiple people being logged in at the same time.

## Remote Lab

As shown in the demonstration session, the whole exercise part of the course can be done remotely via our *Remote Lab*.
Please run the following command on the computer from which you want to access the Remote Lab (i.e., most probably the VM).

```
pip install git+https://git.inf2.tuwien.ac.at/sw/rpatools
```

This command installs the tools `rpa_shell` and `rpa_gui`, RPA standing for Remote Place Assigner.

### RPA Configuration
Open a terminal and run `rpa_shell`.
When you run this the first time, a configuration wizard will be executed.
The URL is `ssh.tilab.tuwien.ac.at`, the username is the one you also use for the lab (`m` followed by your student id).
Next, the wizard will ask you if you already created an SSH key.
If you did, you can enter `y` and then specify its location.
Otherwise, or if you want a dedicated new key, you can enter `n` and let the wizard create one for you (the passphrase is optional).
Then, you have to type in your lab password, after which the tool will create a connection to a lab computer equipped with an FPGA board.

**Note**: If you made a mistake during the configuration process, you can rerun the wizard via `rpa_shell --run-setup`

### Usage
After the successful initial configuration, you can access the lab remotely.
To do so, simply run `rpa_shell` which will connect you to a computer in the remote lab (if none is currently free you are placed in a queue for a few minutes).
This connection is the *master process* (and the respective shell the master shell).
By executing `rpa_shell` again, you can open as many *sub*-connections to your assigned lab computer as you need.
By hitting `Ctrl+D` or entering `exit` in the master shell, all connections to the remote computer will be closed.

Note that the tools (QuestaSim, Quartus) and the FPGA board are remotely **only** accessible via these connections.

#### Download to FPGA
After the initial configuration, the `rpa_shell` also allows to remotely download a bitstream you generated, e.g., in the VM, to an FPGA.
You can either do so using the task Makefiles and the `qdownload_remote` target.

#### Video Stream
In order to observe the FPGA, e.g., the LEDs, seven-segment displays or the display, the RPA tools also provide you with a live-stream of the board.
You can access it via `rpa_shell -s target`.
However, be aware that the stream can be a bit delayed.

#### remote.py
Obviously viewing the outputs of the FPGA is only one part of remotely interfacing with it.
In addition to that you also need a way to remotely access the inputs (buttons and switches in our case).
This can be achieved by using the `remote.py` tool inside an active rpa shell.
You can open this tool in the interactive mode using `remote.py -i`.
This will open a program that shows the current state of LEDs, seven-segment displays, switches and buttons.
It also allows you to control the switches and buttons (hit `h` for the key bindings).
Below you can find an image of how this program looks like

![remotepy](.mdata/remotepy.png)

Note that `remote.py` provides you further with the functionality to access the I/O from the CLI alone.
Feel free to call `remote.py --help` for more details.

# Allowed Quartus Warnings
You can observe that Quartus produces multiple warnings, although the design is correct.
Quartus does this to highlight some possible irregularities which are, in this case, fine and can thus be ignored.
To reflect this, the stream of warnings can be filtered such that certain warnings are no longer shown.
We already configured Quartus accordingly for the other tasks.
However, some warnings could still be potentially problematic and are hence shown.
Make sure to only submit designs were you can argue why certain warnings are alright, we will ask you about them during the exercise session.


# Deliverables

After successful synthesis, open the `Technology Map Viewer (Post-Fitting)` via `Tools -> Netlist Viewers`.
This will show you your design after the technology mapping.
Find the `demo` module and make a screenshot of its implementation.
Also: By right-clicking on a logic element you can view the configuration of its LUT (via `Properties`).
Make a screenshot showing both, the implementation of the module and the truth table of a logic element inside it.
Name it `demo.png` and put it into the task folder (make sure that it was included with the upload!).

Furthermore, we will ask you during the exercise presentation to demonstrate the whole flow of this task, including the download to the board.
Therefore, ensure that you are familiar with the Makefile targets and the RPA tools.


[Return to main page](../../readme.md)
