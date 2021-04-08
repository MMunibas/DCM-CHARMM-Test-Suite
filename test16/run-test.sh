#!/bin/bash

# IN THIS EXAMPLE CHARMM'S THERMODYNAMIC INTEGRATION (PERT) ROUTINES ARE TESTED FOR SINGLE POINT ENERGIES.
# THE SYSTEM EXAMINED IS PHF IN A SOLVENT BOX, CENTRAL CHARGES ARE USED TO ALLOW DIRECT COMPARISON WITH
# STANDARD CHARMM ROUTINES. THE LAMBDA=0 STATE HAS FULL CHARGES, THE LAMBDA=1 STATE HAS ZERO CHARGES, THE
# ENERGIES CORRESPOND TO LAMBDA VALUES OF 0.0, 0.7 AND 1.0. PME IS USED FOR ELECTROSTATICS.

LOG1=lambda_.625_ref.log
LOG2=lambda_.625_dcm.log

[[ -f $LOG1 ]] && rm $LOG1
[[ -f $LOG2 ]] && rm $LOG2

ulimit -s 10240

mpirun -np $NPROC $REFCHARMM -i lambda_.625_ref.inp -o $LOG1 >& errlog1
mpirun -np $NPROC $DEVCHARMM -i lambda_.625_dcm.inp -o $LOG2 >& errlog2

echo "PHF IN WATERBOX WITH PME; PERT ENERGY CALCULATION (STANDARD CHARMM VS. DCM ROUTINES)"
echo
echo $LOG1
echo "lambda 0.0"
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG1 | tail -3 | head -1; done
echo "lambda 0.7"
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG1 | tail -2 | head -1; done
echo "lambda 1.0"
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG1 | tail -1; done
echo

echo $LOG2
echo "lambda 0.0"
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG2 | tail -3 | head -1; done
echo "lambda 0.7"
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG2 | tail -2 | head -1; done
echo "lambda 1.0"
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG2 | tail -1; done
echo
echo "CHECK FORCES AND VIRIAL:"
grep " ( WAT" $LOG2
grep " CUBI " $LOG2
