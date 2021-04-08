#!/bin/bash

#SBATCH --job-name=dcm-cpt
#SBATCH --nodes=1
#SBATCH --ntasks=8 
#SBATCH --partition=long

# THIS TEST LOOKS AT A SOLVATED TRIPEPTIDE IN A WATERBOX WITH PATCHED RESIDUES AT EACH END OF THE
# TRIPEPTIDE CHAIN. ELECTROSTATICS ARE MODELLED USING PARTICLE MESH EWALD, DCM CHARGES ARE USED TO
# CREATE TIP4P WATER MOLECULES AND TO ADD MULTIPOLES TO CERTAIN PEPTIDE ATOMS. CPT DYNAMICS ARE RUN
# (CONSTANT PRESSURE AND TEMPERATURE) TO CHECK THAT STABLE SIMULATION BOX VOLUMES AND REASONABLE
# PRESSURES ARE OBTAINED.


export DEVCHARMM=/opt/cluster/programs/charmm/developer/dev-release-dcm/build/cmake/charmm # development version to be tested
export NPROC=4 # number of MPI cores to use for the tests

# Set up the environment for the CHARMM code referenced above
module load gcc/gcc-9.2.0-openmpi-4.0.2-ib


LOG2=charmm-patch-dev.out

[[ -f $LOG2 ]] && rm $LOG2

ulimit -s 10240

#mpirun -np $NPROC $DEVCHARMM -i dcm-triala.inp -o $LOG2 >& errlog
srun $DEVCHARMM -i dcm-triala.inp -o $LOG2 >& errlog

grep "DYNA PRESS>" charmm-patch-dev.out | awk '{print $7}' > vol.dat
grep "DYNA PRESS>" charmm-patch-dev.out | awk '{print $6}' > pressi.dat
grep "DYNA PRESS>" charmm-patch-dev.out | awk '{print $5}' > presse.dat

echo
echo "PME CPT RUN COMPLETE, CHECK VOL.DAT FOR BOX VOLUME, PRESSE.DAT FOR EXTERNAL PRESSURE,"
echo "PRESSI.DAT FOR INTERNAL PRESSURE (BASED ON INTERNAL AND EXTERNAL VIRIAL)"
echo
