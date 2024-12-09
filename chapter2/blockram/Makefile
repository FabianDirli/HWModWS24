VHDL_FILES =\
	../../lib/math/src/math_pkg.vhd\
	../../lib/util/src/util_pkg.vhd\
	../../lib/top/src/top.vhd\
	src/simple_dp_ram.vhd\
	tb/simple_dp_ram_tb.vhd\
	top_arch.vhd

TB=simple_dp_ram_tb
WAVE_FILE=wave.do

include ../../util/simple_flow.mk

include ../../util/quartus.mk

check: gsim
	@d=$$(sort -n -t ':' -k 1 tb/debugdata_in.txt | diff - tb/debugdata_out.txt 2>&1);\
	if [[ $$(printf "%s" $$d | wc -c) -ne 0 ]]; then \
		echo "$$d";\
		echo "check failed!";\
	else \
		echo "check passed!"; \
	fi;
