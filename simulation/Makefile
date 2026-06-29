TB_TOP ?= tb_top
TESTNAME ?= TestBase

RUN_DIR = run_case.$(TESTNAME)

.PHONY: base vcs simv verdi all clean

######################################################
base:
	@echo "Creating run directory: $(RUN_DIR)"
	@mkdir -p $(RUN_DIR)
	@mkdir -p $(RUN_DIR)/run_vcs
	@mkdir -p $(RUN_DIR)/run_vcs/log
	@mkdir -p $(RUN_DIR)/run_vcs/output
	@mkdir -p $(RUN_DIR)/run_vcs/output/wave
	@cd $(RUN_DIR) && ln -sf ../base
	@cd $(RUN_DIR) && ln -sf ../../rtl
	@cd $(RUN_DIR) && ln -sf ../../testbench
	@cd $(RUN_DIR) && ln -sf ../../filelists
	@cd $(RUN_DIR)/filelists/merge_all_filelist && python merge_all_filelist.py -t ../all.f

######################################################
# note: 指定 -o 包括了 simv 和 simv.daidir
# note: 指定 -Mdir 包括了 csrc 和 vc_hdrs.h

# VCS  = vcs -full64 -LDFLAGS -Wl,--no-as-needed
VCS  = vcs -full64
VCS += -file ../base/option/compile_base.f
VCS += -file ../base/option/compile_uvm.f
VCS += -file ../filelists/merge_all_filelist/merged.f
VCS += +optconfigfile+../base/option/vcs.cfg
VCS += -l ./log/vcs.log
VCS += -o ./output/simv
VCS += -Mdir=./output/csrc
VCS += -top $(TB_TOP)

vcs: base
	cd $(RUN_DIR)/run_vcs && $(VCS)

######################################################
SIMV  = ./output/simv +UVM_TESTNAME=$(TESTNAME)
SIMV += -f ../base/option/simulate_base.f
SIMV += -l ./log/simv.log
SIMV += -k ./output/ucli.key

simv: vcs
	cd $(RUN_DIR)/run_vcs && $(SIMV) && rm -rf novas_dump.log

######################################################
clean:
	cd $(RUN_DIR) && find . -maxdepth 1 -type l -delete

######################################################
all: simv
	$(MAKE) clean

######################################################
VERDI  = verdi
VERDI += -ssf $(abspath $(RUN_DIR)/run_vcs/output/wave/novas.vf)
VERDI += -dbdir ../run_vcs/output/simv.daidir
VERDI += -logdir ../run_vcs/log/verdiLog
VERDI += -rcFile ../../base/novas/novas.rc
VERDI += -guiConf ../../base/novas/novas.conf

verdi:
	@mkdir -p $(RUN_DIR)/run_verdi
	cd $(RUN_DIR)/run_verdi && $(VERDI) &
