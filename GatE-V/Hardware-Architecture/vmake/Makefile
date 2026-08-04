# GatE-V FPGA — Build & Simulation
# Run 'make' or 'make help' to see all available targets.

VIVADO   ?= vivado
PRJ_DIR  ?= ../GatE-V
SCRIPTS  ?= scripts
RTL      ?= rtl
PRJ_SRC_DIR = $(PRJ_DIR)/src
LIB_PATH  ?= /usr/lib/x86_64-linux-gnu:/usr/lib32
NUM_TILES ?= 4

.PHONY: all help gatev bd open sim sim-gui synth questa questa-gui clean prepare

# ── Default: show help ────────────────────────────────────────────
all: help

# ── Help Menu ─────────────────────────────────────────────────────
help:
	@printf "\n"
	@printf "  \033[1;36m╭──────────────────────────────────────────────────────╮\033[0m\n"
	@printf "  \033[1;36m│\033[0m  \033[1;37m🔧 GatE-V FPGA Build System\033[0m                         \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m                                                      \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m  \033[1;33mSIMULATE\033[0m                                            \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m    \033[1;32mmake questa\033[0m          \033[0;37mQuesta sim (batch)\033[0m           \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m    \033[1;32mmake questa-gui\033[0m      \033[0;37mQuesta sim (GUI+waveforms)\033[0m   \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m    \033[1;32mmake sim\033[0m             \033[0;37mVivado XSim (batch)\033[0m          \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m    \033[1;32mmake sim-gui\033[0m         \033[0;37mVivado XSim (GUI)\033[0m            \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m                                                      \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m  \033[1;33mVIVADO BUILD\033[0m                                        \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m    \033[1;32mmake synth\033[0m           \033[0;37mSynthesize design\033[0m            \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m    \033[1;32mmake bd\033[0m              \033[0;37mBlock Design only\033[0m            \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m    \033[1;32mmake gatev\033[0m           \033[0;37mFull flow (bd+synth)\033[0m         \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m    \033[1;32mmake prepare\033[0m         \033[0;37mSync RTL -> Vivado project\033[0m   \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m    \033[1;32mmake open\033[0m            \033[0;37mOpen Vivado project GUI\033[0m      \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m                                                      \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m  \033[1;33mUTILITY\033[0m                                             \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m    \033[1;32mmake clean\033[0m           \033[0;37mRemove all build artifacts\033[0m   \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m                                                      \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m  \033[1;33mOPTIONS\033[0m                                             \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m    \033[1;32mNUM_TILES=N\033[0m          \033[0;37mTile count 1-4 (default: 4)\033[0m  \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m│\033[0m    \033[0;37me.g. make sim NUM_TILES=2\033[0m                         \033[1;36m│\033[0m\n"
	@printf "  \033[1;36m╰──────────────────────────────────────────────────────╯\033[0m\n\n"
	@echo ""

prepare:
	@mkdir -p $(PRJ_SRC_DIR)
	@cp -r $(RTL) $(PRJ_SRC_DIR)/
	@cp -r constraints $(PRJ_SRC_DIR)/ 2>/dev/null || true
	@cp -r board_files $(PRJ_SRC_DIR)/ 2>/dev/null || true

# ── Open Vivado GUI ──────────────────────────────────────────────
open:
	$(VIVADO) $(PRJ_DIR)/GatE-V.xpr &

# ── Block Design (batch) ─────────────────────────────────────────
bd: prepare
	$(VIVADO) -mode batch -source $(SCRIPTS)/vivado_create_bd.tcl -tclargs $(PRJ_DIR) $(PRJ_SRC_DIR)

# ── Full Flow ────────────────────────────────────────────────────
gatev: bd synth sim

# ── Vivado Synthesis (batch) ─────────────────────────────────────
synth: prepare bd
	$(VIVADO) -mode batch -source $(SCRIPTS)/vivado_synth.tcl -tclargs $(PRJ_DIR)

# ── Vivado Simulation (batch) ────────────────────────────────────
sim: prepare
	LIBRARY_PATH=$(LIB_PATH) $(VIVADO) -mode batch -source $(SCRIPTS)/vivado_sim.tcl -tclargs $(PRJ_DIR) $(PRJ_SRC_DIR) $(NUM_TILES)

sim-gui: prepare
	LIBRARY_PATH=$(LIB_PATH) $(VIVADO) -source $(SCRIPTS)/vivado_sim.tcl -tclargs $(PRJ_DIR) $(PRJ_SRC_DIR) $(NUM_TILES)

# ── Questa Simulation ───────────────────────────────────────────
questa: prepare
	vsim -c -do "do sim/run.do"

questa-gui: prepare
	vsim -do "do sim/run.do"

# ── Clean ────────────────────────────────────────────────────────
clean:
	@rm -rf .Xil *.jou *.log *.backup* *.str *.vcd *.fst *.pb *.dir *.wlf wlft* work transcript
	@rm -rf $(PRJ_DIR)
	@echo "\033[1;32m✓ Clean complete\033[0m"
