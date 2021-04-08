#!/bin/bash

#SBATCH --job-name=dcm-nve
#SBATCH --nodes=1
#SBATCH --ntasks=8 
#SBATCH --partition=long

# THIS TEST LOOKS AT A SOLVATED TRIPEPTIDE IN A WATERBOX WITH PATCHED RESIDUES AT EACH END OF THE TRIPEPTIDE
# CHAIN. ELECTROSTATICS ARE MODELLED USING PARTICLE MESH EWALD, CENTRAL CHARGES ARE USED TO ALLOW DIRECT
# COMPARISON OF CHARMM'S "LONEPAIR" ROUTINE AND DCM CODE (CENTRAL CHARGES ARE ALSO DEFINED IN THE DCM PARAMETER
# FILE)

export DEVCHARMM=/opt/cluster/programs/charmm/developer/dev-release-dcm/build/cmake/charmm # development version to be tested
export NPROC=4 # number of MPI cores to use for the tests

# Set up the environment for the CHARMM code referenced above
module load gcc/gcc-9.2.0-openmpi-4.0.2-ib


LOG2=charmm-patch-dev.out

[[ -f $LOG2 ]] && rm $LOG2

ulimit -s 10240

#mpirun -np $NPROC $DEVCHARMM -i dcm-triala.inp -o $LOG2 >& errlog
srun $DEVCHARMM -i dcm-triala.inp -o $LOG2 >& errlog

