#!/bin/bash

# THIS TEST COMPARES THE DCM DEVELOPMENT CODE WITH STABLE DCM CODE FOR "FSHIFTED" CUTOFFS
# BETWEEN CHARGE POSITIONS AND WITH DIPOLAR POLARIZABILITIES
# 10 CHARGES ARE USED FOR A TIP4P-LIKE ARRANGMENT (BUT WITH TIP3P CHARGE MAGNITUDES) TO CHECK
# STABILITY OF DCM ROUTINE

LOG1=waterbox-dcm-ref.out
LOG2=waterbox-dcm-dev.out

[[ -f $LOG1 ]] && rm $LOG1
[[ -f $LOG2 ]] && rm $LOG2

ulimit -s 10240

mpirun -np $NPROC $REFCHARMM -i waterbox-dcm.inp -o $LOG1 >& errlog1
mpirun -np $NPROC $DEVCHARMM -i waterbox-dcm.inp -o $LOG2 >& errlog2

echo "DCM vs. OLD CODE TFSHIFT + POLARIZATION"
echo
echo $LOG1
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG1 | tail -1; done
grep "DCM EPOL>" $LOG1 | sed -n 2p
echo
echo $LOG2
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG2 | tail -1; done
grep "DCM EPOL>" $LOG2 | head -1
echo
echo "CHECK FORCES AND VIRIAL:"
grep "( WAT" $LOG2
grep "CUBI crystal" $LOG2
