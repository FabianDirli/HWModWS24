VHDL_FILES =\
	src/counter.vhd\
	../../lib/util/src/util_pkg.vhd\
	../../lib/top/src/top.vhd\
	top_arch.vhd\
	tb/top_tb.vhd

TB=top_tb
WAVE_FILE=wave.do
GTK_WAVE_FILE=wave.gtk

include ../../util/simple_flow.mk

include ../../util/quartus.mk


QUARTUS_SIM_DIR=quartus/simulation/questa

#VHO=$(QUARTUS_SIM_DIR)/top_7_1200mv_85c_slow.vho
#SDO=$(QUARTUS_SIM_DIR)/top_7_1200mv_85c_vhd_slow.sdo

#VHO=$(QUARTUS_SIM_DIR)/top_7_1200mv_0c_fast.vho
#SDO=$(QUARTUS_SIM_DIR)/top_7_1200mv_0c_vhd_fast.sdo

VHO=$(QUARTUS_SIM_DIR)/top.vho
SDO=$(QUARTUS_SIM_DIR)/top_vhd.sdo


sim_pl:
	vlib work
	vcom $(VCOM_ARGS) $(VHO)
	vcom $(VCOM_ARGS) tb/top_tb.vhd
	vsim $(VSIM_ARGS) -c -do "vsim top_tb -t 1ps -sdftyp /uut=$(SDO); run -all; exit;"


sim_pl_gui:
	vlib work
	vcom $(VCOM_ARGS) $(VHO)
	vcom $(VCOM_ARGS) tb/top_tb.vhd
	vsim -do "vsim $(VSIM_ARGS) top_tb -t 1ps -sdftyp /uut=$(SDO); do wave.do; run -all"
