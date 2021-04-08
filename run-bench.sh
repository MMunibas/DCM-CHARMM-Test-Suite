#!/bin/bash

# This script calls each of the DCM benchmarking tests in the range STRT to STOP

# Set some variables to be used by the test scripts
export DEVCHARMM=/opt/cluster/programs/charmm/developer/dev-release-dcm/build/cmake/charmm # development version to be tested
export REFCHARMM=/home/devereux/c45a1/build/cmake/charmm # reference stable CHARMM release
export NPROC=4 # number of MPI cores to use for the tests
export WORKDIR=$(pwd) # Set the root folder containing the tests

# Set some local parameters
STRT=1  # First test to run
STOP=4 # Last test to run

GREEN='\033[1;32m'
NC='\033[0m' # No Color

# Set up the environment for the CHARMM code referenced above
module load gcc/gcc-9.2.0-openmpi-4.0.2-ib

# Now we start the tests
for i in $(seq $STRT 1 $STOP); do
  if [[ -d bench$i ]]; then
    echo
    printf "${GREEN}BENCH$i:${NC}\n\n"
    cd bench$i
  else
    echo " Error: directory bench$i not found in $WORKDIR"
    exit 0
  fi
  ./run-bench.sh
  cd $WORKDIR
done

echo
echo "DONE. EXITING."
echo
