#!/bin/bash

# THIS TEST LOOKS AT A SOLVATED TRIPEPTIDE IN A WATERBOX WITH PATCHED RESIDUES AT EACH END OF THE TRIPEPTIDE
# CHAIN. ELECTROSTATICS ARE MODELLED USING PARTICLE MESH EWALD, OFF-CENTER CHARGES ARE DEFINED AND COMBINED
# WITH ATOMIC DIPOLAR POLARIZABILITIES TO TEST USE OF THIS COMBINATION. NO REFERENCE CODE CURRENTLY EXISTS FOR
# COMPARISON, SO THE TEST IS FOR CORRECT FORCES ONLY.

LOG2=charmm-patch-dev.out

[[ -f $LOG2 ]] && rm $LOG2

ulimit -s 10240

mpirun -np $NPROC $DEVCHARMM -i dcm-triala.inp -o $LOG2 >& errlog2

echo "PATCHED SOLVATED TRIPEPTIDE WITH EWALD + POLARIZATION DEV CODE FORCES"
echo
echo $LOG2
for i in "ENER>" "ENER INTERN>" "ENER EXTERN>" "ENER IMAGES>" "ENER EWALD>"; do grep "$i" $LOG2 | tail -1; done
echo
echo "CHECK FORCES AND VIRIAL:"
grep " ( " $LOG2 | grep "LIG"
grep " ( " $LOG2 | grep "CLA"
grep " CUBI " $LOG2
