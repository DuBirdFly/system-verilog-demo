TESTNAME ?= TestBase

RUN_DIR = run_case.$(TESTNAME)

.PHONY: base vcs simv verdi all clean

######################################################
base:
	mkdir -p $(RUN_DIR)
	mkdir -p $(RUN_DIR)/log
	mkdir -p $(RUN_DIR)/wave
	cd $(RUN_DIR) && ln -sf ../base
	cd $(RUN_DIR) && ln -sf ../../dut
	cd $(RUN_DIR) && ln -sf ../../filelist
	cd $(RUN_DIR) && ln -sf ../../sim

######################################################
# VCS  = vcs -full64 -LDFLAGS -Wl,--no-as-needed
VCS  = vcs -full64
VCS += -file ./base/option/vcs.f
VCS += -f ./base/filelist/dut.lis
VCS += -f ./base/filelist/sim.lis
VCS += -l ./log/vcs.log

vcs:
	cd $(RUN_DIR) && $(VCS) +define+DUMP_FSDB

######################################################
SIMV  = ./simv +UVM_TESTNAME=$(TESTNAME)
SIMV += -f ./base/option/simv.f
SIMV += -l ./log/simv.log

simv:
	cd $(RUN_DIR) && $(SIMV)

######################################################
VERDI  = verdi
VERDI += -ssf ./wave/novas.vf
VERDI += -rcFile ./base/novas/novas.rc
VERDI += -guiConf ./base/novas/novas.conf
VERDI += -logdir ./log/verdiLog

verdi:
	cd $(RUN_DIR) && $(VERDI) &

######################################################
all:
	$(MAKE) base
	$(MAKE) vcs
	$(MAKE) simv

# clean:
# 	cd $(RUN_DIR) && 