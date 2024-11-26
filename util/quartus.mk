current_dir := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

ifndef QUARTUS_PROJECT_DIR
QUARTUS_PROJECT_DIR=quartus
endif


QUARTUS_QPF=$(shell ls $(QUARTUS_PROJECT_DIR)/*.qpf 2>/dev/null)
QUARTUS_QSF=$(shell ls $(QUARTUS_PROJECT_DIR)/*.qsf 2>/dev/null)
QUARTUS_PROJECT_NAME=$(shell basename $(QUARTUS_QSF) .qsf)
QUARTUS_LOG_FILE=$(QUARTUS_PROJECT_DIR)/BUILD_$(shell date '+%d.%m.%y-%H_%M_%S').log

qcompile: $(QUARTUS_QPF) $(QUARTUS_QSF)
	quartus_sh --flow compile $(QUARTUS_QPF) 2>&1 | tee -a $(QUARTUS_LOG_FILE)
	@echo "-------------------------------------------------------------------------------"
	@echo "--                Quartus Errors and Warnings Overview                        -"
	@echo "--                  (for more details see build log)                          -"
	@echo "-------------------------------------------------------------------------------"
	@export GREP_COLOR="01;33"; cat $(QUARTUS_LOG_FILE) | grep --color -e "^Warning [\(][0-9]*[\)]:" || true
	@export GREP_COLOR="1;35"; cat $(QUARTUS_LOG_FILE) | grep -e "^Critical Warning [\(][0-9]*[\)]:" || true
	@export GREP_COLOR="1;31"; cat $(QUARTUS_LOG_FILE) | grep -e "^Error [\(][0-9]*[\)]:" || true

qclean:
	@for ext in sopcinfo html cmp rpt bsf dpf jdi html qws smsg summary qdf qxp qarlog done sld pin log; do \
		rm -f $(QUARTUS_PROJECT_DIR)/*.$$ext; \
	done;
	@for d in output_files incremental_db simulation db; do\
		rm -fr $(QUARTUS_PROJECT_DIR)/$$d; \
	done;

qgui:
	quartus --64bit $(QUARTUS_QPF) &

qdownload:
	quartus_pgm -m jtag -o"p;$(QUARTUS_PROJECT_DIR)/output_files/$(QUARTUS_PROJECT_NAME).sof"

qdownload_remote:
	rpa_shell -p $(QUARTUS_PROJECT_DIR)/output_files/$(QUARTUS_PROJECT_NAME).sof

.PHONY: qcompile
.PHONY: qclean
.PHONY: qdownload
.PHONY: qgui

