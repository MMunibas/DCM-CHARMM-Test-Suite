#!/bin/bash

# BENCHMARK TEST FOR DCM CODE WITH SINGLE OFF-CENTER CHARGE ALONG H2O ANGLE BISECTOR VS CHARMM'S
# LONEPAIR ROUTINE. A SHORT MINIMIZATION IS FOLLOWED BY HEATING DURING A SHORT DYNAMICS RUN. SMOOTH
# "SHIFTED" CUTOFFS ARE USED WITHOUT EWALD SUMMATION

LOG1=waterbox-ref.out
LOG2=waterbox-dcm.out

[[ -f $LOG1 ]] && rm $LOG1
[[ -f $LOG2 ]] && rm $LOG2

ulimit -s 10240

echo
echo "TSHIFT WITH TIP4P: NEW CODE VS CHARMM LONEPAIR ROUTINE"
echo "500 SD MINIMIZATION STEPS, 1000 DYNAMICS STEPS"
echo "LONEPAIR CODE"
time mpirun -np $NPROC $REFCHARMM -i waterbox-lp.inp -o $LOG1 >& errlog1

echo
echo "NEW CODE"
time mpirun -np $NPROC $DEVCHARMM -i waterbox-dcm.inp -o $LOG2 >& errlog2
