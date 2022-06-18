.PHONY: ao486_clean ao486 ao486_run ao486_build ao486_sim_build

RTL_TIMEOUT?=10000
SIMS_BUILD=build/manycore/rel-0.1
MEMIMAGE=build/mem.image


# x86_as build, generates outputs in the same folder in which the input files are
ao486_build ${MEMIMAGE}: ${PITON_ROOT}/piton/verif/diag/assembly/include/x86/bios/
	@echo "Building ao486 mem.image"
	cd "${PITON_ROOT}/build" && \
		mkdir -p ao486_rombios_build && \
		cd "${PITON_ROOT}/build/ao486_rombios_build" && \
			rsync -Pav "${PITON_ROOT}/piton/verif/diag/assembly/include/x86/bios/" ./ && \
			${PITON_ROOT}/piton/tools/bin/x86_as && \
    		mv mem.image ../mem.image && \
			echo "mem.image build" || \
    		echo "failed to build mem.image"

ao486_sim_build ${SIMS_BUILD}: ${MEMIMAGE}
	@echo "Building ao486_sim (icv)"
	# This builds the verilog simulation for icv (icarus verilog)
	cd "${PITON_ROOT}/build" && \
		sims -sys=manycore -icv_build -ao486 -vcd && \
		echo "ao486_sim (icv) built" || \
		echo "failed to build ao486_sim (icv)"

ao486 ao486_run: ${SIMS_BUILD}
	@echo "ao486_running"
	cd "${PITON_ROOT}/build" && \
		sims -sys=manycore -icv_run -ao486 -vcd -rtl_timeout ${RTL_TIMEOUT} > /dev/null && \
		echo "ao486_sim (icv) ran" || \
		echo "failed to run, or finish running ao486_sim (icv)"
