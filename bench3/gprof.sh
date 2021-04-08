#!/bin/bash

LOG2=waterbox-dcm.out

ulimit -s 10240

module load gcc/gcc-9.2.0-openmpi-4.0.2-ib

cd /home/devereux/mdcm-pme/test-suite/bench3

echo
echo "PROFILING..."
/opt/cluster/programs/charmm/developer/dev-release-dcm/build/cmake/charmm -i waterbox-dcm.inp -o $LOG2
gprof -b /opt/cluster/programs/charmm/developer/dev-release-dcm/build/cmake/charmm gmon.out > gprof.log
gprof -l -b /opt/cluster/programs/charmm/developer/dev-release-dcm/build/cmake/charmm gmon.out > gprof-line-by-line.log
