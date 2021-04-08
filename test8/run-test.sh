#!/bin/bash

# THIS TEST CHECKS THE STABILITY OF A SPARSE DCM SYSTEM WITH A SINGLE OFF-CENTER CHARGE ON ONE OF THE ATOMS

LOG2=waterbox-dcm.out

[[ -f $LOG2 ]] && rm $LOG2

ulimit -s 10240

mpirun -np $NPROC $DEVCHARMM -i waterbox-dcm.inp -o $LOG2 >& errorlog

echo
echo "DCM WITH SINGLE CHARGE ON CENTRAL ATOM"
echo
echo $LOG2
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG2 | tail -1; done
echo
echo "CHECK FORCES AND VIRIAL:"
grep "( WAT" $LOG2
grep "CUBI crystal" $LOG2
