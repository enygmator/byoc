#!/bin/sh

mkdir -p ao486_build
cd "${PITON_ROOT}/build/ao486_build"
rsync -Pav "${PITON_ROOT}/piton/verif/diag/assembly/include/x86/bios/" ./
$PITON_ROOT/piton/tools/bin/x86_as && \
    mv mem.image ../mem.image || \
    echo "failed to build"
cd ..
sims -sys=manycore -icv_build -ao486 -vcd && \
sims -sys=manycore -icv_run -ao486 -vcd -rtl_timeout 1000000
