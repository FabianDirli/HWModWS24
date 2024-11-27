VHDL_FILES =\
	../../lib/math/src/math_pkg.vhd\
	../../lib/util/src/util_pkg.vhd\
	src/adder4.vhd\
	src/generic_adder.vhd\
	tb/generic_adder_tb.vhd\
	../../lib/top/src/top.vhd\
	top_arch.vhd

TB=generic_adder_tb
WAVE_FILE=

sim_exhaustive: VSIM_USER_ARGS=-GTESTMODE=exhaustive
sim_exhaustive: sim

sim_gui_exhaustive: VSIM_USER_ARGS=-GTESTMODE=exhaustive
sim_gui_exhaustive: sim_gui

sim_fibonacci: VSIM_USER_ARGS=-GTESTMODE=fibonacci
sim_fibonacci: sim

sim_gui_fibonacci: VSIM_USER_ARGS=-GTESTMODE=fibonacci
sim_gui_fibonacci: sim_gui

gsim_exhaustive: GHDL_USER_ARGS=-gTESTMODE=exhaustive
gsim_exhaustive: gsim

gsim_gui_exhaustive: GHDL_USER_ARGS=-gTESTMODE=exhaustive
gsim_gui_exhaustive: gsim_gui

gsim_fibonacci: GHDL_USER_ARGS=-gTESTMODE=fibonacci
gsim_fibonacci: gsim

gsim_gui_fibonacci: GHDL_USER_ARGS=-gTESTMODE=fibonacci
gsim_gui_fibonacci: gsim_gui


include ../../util/simple_flow.mk

include ../../util/quartus.mk
