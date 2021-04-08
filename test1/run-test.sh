#!/bin/bash

# THIS TEST COMPARES THE DCM DEVELOPMENT CODE WITH CHARMM'S LONEPAIR ROUTINE WITH EWALD SUMMATION
# 10 CHARGES ARE USED FOR A TIP4P-LIKE ARRANGMENT (BUT WITH TIP3P CHARGE MAGNITUDES) TO CHECK
# STABILITY OF DCM ROUTINE

LOG1=waterbox-lp.out
LOG2=waterbox-dcm.out

[[ -f $LOG1 ]] && rm $LOG1
[[ -f $LOG2 ]] && rm $LOG2

ulimit -s 10240

mpirun -np $NPROC $REFCHARMM -i waterbox-lp.inp -o $LOG1 >& errlog1

mpirun -np $NPROC $DEVCHARMM -i waterbox-dcm.inp -o $LOG2 >& errlog2

echo "DCM vs. LONEPAIR EWALD"
echo
echo $LOG1
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG1 | tail -1; done
echo
echo $LOG2
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG2 | tail -1; done
echo
echo "CHECK FORCES AND VIRIAL:"
grep "( WAT" $LOG2
grep "CUBI crystal" $LOG2
