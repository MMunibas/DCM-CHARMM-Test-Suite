#!/bin/bash

#SBATCH --job-name=dcm-nve
#SBATCH --nodes=1
#SBATCH --ntasks=8 
#SBATCH --partition=long

# THIS TEST LOOKS AT A SOLVATED TRIPEPTIDE IN A WATERBOX WITH PATCHED RESIDUES AT EACH END OF THE
# TRIPEPTIDE CHAIN. ELECTROSTATICS ARE MODELLED USING PARTICLE MESH EWALD, DCM CHARGES ARE USED TO
# CREATE TIP4P WATER MOLECULES AND TO ADD MULTIPOLES TO CERTAIN PEPTIDE ATOMS. NVE DYNAMICS ARE RUN
# (CONSTANT TOTAL ENERGY) TO CHECK THAT THE ENERGY SURFACE AND FORCES ARE DESCRIBED CORRECTLY
# DURING SIMULATIONS AND TOTAL SIMULATION ENERGY IS THEREBY CONSERVED.


export DEVCHARMM=/opt/cluster/programs/charmm/developer/dev-release-dcm/build/cmake/charmm # development version to be tested
export NPROC=4 # number of MPI cores to use for the tests

# Set up the environment for the CHARMM code referenced above
module load gcc/gcc-9.2.0-openmpi-4.0.2-ib


LOG2=charmm-patch-dev.out

[[ -f $LOG2 ]] && rm $LOG2

ulimit -s 10240

#mpirun -np $NPROC $DEVCHARMM -i dcm-triala.inp -o $LOG2 >& errlog
srun $DEVCHARMM -i dcm-triala.inp -o $LOG2 >& errlog

grep "DYNA>" $LOG2 | awk '{print $4}' > ener.dat

echo
echo "PME NVE RUN COMPLETE, CHECK ENER.DAT FOR ENERGY CONSERVATION"
echo
