ifndef CLEAN_MK
CLEAN_MK=1

clean:
	rm -f transcript
	rm -f vsim.wlf
	rm -f *log
	rm -fr work
	rm -f *.cf
	rm -f *.o
	rm -f *.dump.ghw
	rm -f *.ppm
	rm -f $(CLEAN_FILES)
	rm -rf $(CLEAN_DIRS)


.PHONY: clean

################################################################################
#                             HELP TEXT                                        #
################################################################################

current_dir := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
include $(current_dir)/common.mk

CLEAN_HELP += $(HELP_SEP_LINE)
CLEAN_HELP += "Provides targets for removing compilation and simulation artifacts\n"
CLEAN_HELP += '***\n'
CLEAN_HELP += "${TARGET_COL}clean${NO_COL}:${HELP_SPACE}Cleans Modelsim and GHDL compilation and simulation artifacts\n"
CLEAN_HELP += '***\n'
CLEAN_HELP += "${VAR_COL}CLEAN_FILES${NO_COL}${HELP_SPACE}Additional file (extensions) for removal (e.g. *.txt img.ppm)\n"
CLEAN_HELP += "${VAR_COL}CLEAN_DIRS${NO_COL}${HELP_SPACE}Additional directories for removal. Removes directories recursively!\n"

HELP_TEXT += $(CLEAN_HELP)

endif
