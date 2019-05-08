#!/bin/sh

set -x

export STACKROOT=$(dirname $PWD)

export PREFIX="${HOME}/opt"
export CHECK="NO"
export PKGDIR="$STACKROOT/pkg"

export OPT=$PREFIX

compilerName="gnu"
compilerVersion="7.4.0"
export COMPILER="$compilerName-$compilerVersion"

# First build utilites that are independent of compiler/mpi
./build_ecbuild.sh "2.9.3" 2>&1 | tee log.ecbuild
./build_eigen.sh "3.3.5" 2>&1 | tee log.eigen

# Next build the GNU compiler
#./build_gnu.sh $compilerVersion 2>&1 | tee log.gnu

# Next build GNU compiler suite
#./build_jasper.sh "1.900.1" 2>&1 | tee log.jasper
#./build_zlib.sh "1.2.8" 2>&1 | tee log.zlib
./build_szip.sh "2.1.1" 2>&1 | tee log.szip
./build_udunits.sh "2.2.26" 2>&1 | tee log.udunits
./build_lapack.sh "3.8.0" 2>&1 | tee log.lapack

./build_fftw.sh "3.3.8" 2>&1 | tee log.fftw
./build_hdf5.sh "1_10_3" 2>&1 | tee log.hdf5
./build_netcdf.sh "4.6.1" "4.4.4" "4.3.0" 2>&1 | tee log.netcdf
./build_boost.sh "1.68.0" 2>&1 | tee log.boost
./build_esmf.sh "7_1_0r" 2>&1 | tee log.esmf
./build_nccmp.sh "1.8.2.1" 2>&1 | tee log.nccmp
./build_eccodes.sh "2.8.2" 2>&1 | tee log.eccodes

# Then build GNU + OpenMPI compiler suite
mpiName="openmpi"
mpiVersion="3.1.2"
export MPI="$mpiName-$mpiVersion"

./build_mpi.sh $mpiName $mpiVersion 2>&1 | tee log.$mpiName
./build_fftw.sh "3.3.8" 2>&1 | tee log.fftw.$mpiName
./build_hdf5.sh "1_10_3" 2>&1 | tee log.hdf5.$mpiName
./build_netcdf.sh "4.6.1" "4.4.4" "4.3.0" 2>&1 | tee log.netcdf.$mpiName
./build_pnetcdf.sh "1.11.1" 2>&1 | tee log.pnetcdf.$mpiName
./build_boost.sh "1.68.0" 2>&1 | tee log.boost.$mpiName
./build_esmf.sh "7_1_0r" 2>&1 | tee log.esmf.$mpiName
./build_baselibs.sh "5.2.2" 2>&1 | tee log.baselibs.$mpiName
./build_eckit.sh "0.23.0" "ecmwf" 2>&1 | tee log.eckit.$mpiName
./build_fckit.sh "develop" "jcsda" 2>&1 | tee log.fckit.$mpiName

# Finally build GNU + MPICH compiler suite
mpiName="mpich"
mpiVersion="3.2.1"
export MPI="$mpiName-$mpiVersion"

./build_mpi.sh $mpiName $mpiVersion 2>&1 | tee log.$mpiName
./build_fftw.sh "3.3.8" 2>&1 | tee log.fftw.$mpiName
./build_hdf5.sh "1_10_3" 2>&1 | tee log.hdf5.$mpiName
./build_netcdf.sh "4.6.1" "4.4.4" "4.3.0" 2>&1 | tee log.netcdf.$mpiName
./build_pnetcdf.sh "1.11.1" 2>&1 | tee log.pnetcdf.$mpiName
./build_boost.sh "1.68.0" 2>&1 | tee log.boost.$mpiName
./build_esmf.sh "7_1_0r" 2>&1 | tee log.esmf.$mpiName
./build_baselibs.sh "5.2.2" 2>&1 | tee log.baselibs.$mpiName
./build_eckit.sh "0.23.0" "ecmwf" 2>&1 | tee log.eckit.$mpiName
./build_fckit.sh "develop" "jcsda" 2>&1 | tee log.fckit.$mpiName

exit 0
