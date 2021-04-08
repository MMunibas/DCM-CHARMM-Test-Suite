#!/bin/bash

# IN THIS EXAMPLE CHARMM'S THERMODYNAMIC INTEGRATION (PERT) ROUTINES ARE TESTED FOR SINGLE POINT ENERGIES.
# THE SYSTEM EXAMINED IS PHF IN A SOLVENT BOX, DCM CHARGES ARE USED AND COMPARED TO RESULTS WITH REFERENCE
# DCM CODE. ATOMS ARE POLARIZABLE, THE LAMBDA=0 STATE HAS FULL CHARGES, THE LAMBDA=1 STATE HAS ZERO CHARGES,
# AND POLARIZABILITIES. THE ENERGIES CORRESPOND TO LAMBDA VALUES OF 0.0, 0.7 AND 1.0. SMOOTH CUTOFFS ARE
# USED WITHOUT EWALD SUMMATION.

LOG1=lambda_.625_ref.log
LOG2=lambda_.625_dcm.log

[[ -f $LOG1 ]] && rm $LOG1
[[ -f $LOG2 ]] && rm $LOG2

ulimit -s 10240

mpirun -np $NPROC $REFCHARMM -i lambda_.625_dcm.inp -o $LOG1 >& errlog1
mpirun -np $NPROC $DEVCHARMM -i lambda_.625_dcm.inp -o $LOG2 >& errlog2

echo "PHF IN WATERBOX WITH POLARIZATION AND DCM CHARGES; PERT ENERGY CALCULATION (REF VS DEV DCM CODE)"
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
grep " ( " $LOG2
grep " CUBI " $LOG2
