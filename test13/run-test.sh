#!/bin/bash

# THIS TEST CREATES A SIMPLE MULTIFRAME PHCL SYSTEM IN A WATER SPHERE WITHOUT PERIODDIC BOUNDARY CONDITIONS.
# THE CENTRAL PHCL MOLECULE AND SOLVENT WATER MOLECULES ARE POLARIZABLE, COMPARISON IS MADE WITH REFERENCE
# DCM CODE.

LOG1=phcl-ref.out
LOG2=phcl-dcm.out

[[ -f $LOG1 ]] && rm $LOG1
[[ -f $LOG2 ]] && rm $LOG2

ulimit -s 10240

mpirun -np $NPROC $REFCHARMM -i phcl-dcm.inp -o $LOG1 >& errlog1
mpirun -np $NPROC $DEVCHARMM -i phcl-dcm.inp -o $LOG2 >& errlog2

echo "PHCL IN WATER DROPLET WITH DCM CHARGES AND POLARIZATION (REF VS DEV CODE)"
echo
echo $LOG1
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG1 | tail -1; done
grep "EPOL" $LOG1 | head -1
echo

echo $LOG2
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG2 | tail -1; done
grep "EPOL" $LOG2 | head -1
echo
echo "CHECK FORCES AND VIRIAL:"
grep " ( MAIN" $LOG2 

