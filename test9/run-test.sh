#!/bin/bash

# THIS TEST CHECKS STABILITY FOR A TRIPEPTIDE SYSTEM WHERE TERMINAL GROUPS WERE ADDED MANUALLY IN THE
# TOPOLOGY AND DCM PARAMETER FILES TO AVOID PATCHING. THE SYSTEM ALSO CONTAINS A MONATOMIC (ION)

LOG1=mdcm-nopatch-ref.out
LOG2=mdcm-nopatch-dev.out

[[ -f $LOG1 ]] && rm $LOG1
[[ -f $LOG2 ]] && rm $LOG2

ulimit -s 10240

mpirun -np $NPROC $REFCHARMM -i mdcm-nopatch-orig.inp -o $LOG1 >& errlog1
mpirun -np $NPROC $DEVCHARMM -i mdcm-nopatch-orig.inp -o $LOG2 >& errlog2

echo "UNPATCHED TRIPEPTIDE WITH MONATOMIC ION, REF DCM CODE VS DEV"
echo
echo $LOG1
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG1 | tail -1; done
echo
echo $LOG2
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG2 | tail -1; done
echo
echo "CHECK FORCES AND VIRIAL:"
grep " ( " $LOG2
