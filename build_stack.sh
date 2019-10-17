#!/bin/sh

set -ex

# Source configuration options
config=${1:-"config/config.sh"}
source $config

export STACKROOT=$(dirname $PWD)

# Build COMPILER libraries
[[ $BUILD_zlib =~ [yYtT] ]] && \
    ush/build_zlib.sh "$VER_zlib" 2>&1 | tee "$LOGdir/log.zlib"

[[ $BUILD_szip =~ [yYtT] ]] && \
    ush/build_szip.sh "$VER_szip" 2>&1 | tee "$LOGdir/log.szip"

[[ $BUILD_udunits =~ [yYtT] ]] && \
    ush/build_udunits.sh "$VER_udunits" 2>&1 | tee "$LOGdir/log.udunits"

[[ $BUILD_lapack =~ [yYtT] ]] && \
    ush/build_lapack.sh "$VER_lapack" 2>&1 | tee "$LOGdir/log.lapack"

[[ $BUILD_boost  =~ [yYtT] ]] && \
    ush/build_boost.sh "$VER_boost" 2>&1 | tee "$LOGdir/log.boost"

[[ $BUILD_eigen =~ [yYtT] ]] && \
    ush/build_eigen.sh "$VER_eigen" 2>&1 | tee "$LOGdir/log.eigen"

[[ $BUILD_fftw  =~ [yYtT] ]] && \
    ush/build_fftw.sh "$VER_fftw" 2>&1 | tee "$LOGdir/log.fftw"

[[ $BUILD_hdf5  =~ [yYtT] ]] && \
    ush/build_hdf5.sh "$VER_hdf5" 2>&1 | tee "$LOGdir/log.hdf5"

[[ $BUILD_netcdf =~ [yYtT] ]] && \
    ush/build_netcdf.sh "$VER_netcdf_c" "$VER_netcdf_f" "$VER_netcdf_cxx" 2>&1 | tee "$LOGdir/log.netcdf"

[[ $BUILD_nccmp     =~ [yYtT] ]] && \
    ush/build_nccmp.sh "$VER_nccmp" 2>&1 | tee "$LOGdir/log.nccmp"

# Now build MPI libraries
set +x
module load $MPI
set -x

[[ $BUILD_boost  =~ [yYtT] ]] && \
    ush/build_boost.sh "$VER_boost" 2>&1 | tee "$LOGdir/log.boost-mpi"

[[ $BUILD_fftw  =~ [yYtT] ]] && \
    ush/build_fftw.sh "$VER_fftw" 2>&1 | tee "$LOGdir/log.fftw-mpi"

[[ $BUILD_hdf5  =~ [yYtT] ]] && \
    ush/build_hdf5.sh "$VER_hdf5" 2>&1 | tee "$LOGdir/log.hdf5-mpi"

[[ $BUILD_pnetcdf =~ [yYtT] ]] && \
    ush/build_pnetcdf.sh "$VER_pnetcdf" 2>&1 | tee "$LOGdir/log.pnetcdf-mpi"

[[ $BUILD_netcdf =~ [yYtT] ]] && \
    ush/build_netcdf.sh "$VER_netcdf_c" "$VER_netcdf_f" "$VER_netcdf_cxx" 2>&1 | tee "$LOGdir/log.netcdf-mpi"






# First build utilites that are independent of compiler/mpi
#./build_ecbuild.sh "2.9.3" 2>&1 | tee log.ecbuild
#./build_eigen.sh "3.3.5" 2>&1 | tee log.eigen

# Next build the GNU compiler
#./build_gnu.sh $compilerVersion 2>&1 | tee log.gnu

# Next build GNU compiler suite
#./build_jasper.sh "1.900.1" 2>&1 | tee log.jasper
#./build_zlib.sh "1.2.8" 2>&1 | tee log.zlib
#./build_szip.sh "2.1.1" 2>&1 | tee log.szip
#./build_udunits.sh "2.2.26" 2>&1 | tee log.udunits
#./build_lapack.sh "3.8.0" 2>&1 | tee log.lapack

#./build_fftw.sh "3.3.8" 2>&1 | tee log.fftw
#./build_hdf5.sh "1_10_3" 2>&1 | tee log.hdf5
#./build_netcdf.sh "4.6.1" "4.4.4" "4.3.0" 2>&1 | tee log.netcdf
#./build_boost.sh "1.68.0" 2>&1 | tee log.boost
#./build_esmf.sh "7_1_0r" 2>&1 | tee log.esmf
#./build_nccmp.sh "1.8.2.1" 2>&1 | tee log.nccmp
#./build_eccodes.sh "2.8.2" 2>&1 | tee log.eccodes

# Then build GNU + OpenMPI compiler suite
mpiName="openmpi"
mpiVersion="4.0.1"
export MPI="$mpiName-$mpiVersion"

export CHECK=YES
./build_mpi.sh $mpiName $mpiVersion 2>&1 | tee log.$mpiName
exit
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
