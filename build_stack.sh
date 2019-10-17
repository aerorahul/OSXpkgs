#!/bin/sh

set -e

export STACKROOT=$(dirname $PWD)

# Source configuration options
config=${1:-"config/config.sh"}
source $config

set -x

# Build COMPILER libraries
[[ $BUILD_zlib =~ [yYtT] ]] && \
    ush/build_zlib.sh "$VER_zlib" 2>&1 | tee "$LOGDIR/log.zlib"

[[ $BUILD_szip =~ [yYtT] ]] && \
    ush/build_szip.sh "$VER_szip" 2>&1 | tee "$LOGDIR/log.szip"

[[ $BUILD_udunits =~ [yYtT] ]] && \
    ush/build_udunits.sh "$VER_udunits" 2>&1 | tee "$LOGDIR/log.udunits"

[[ $BUILD_lapack =~ [yYtT] ]] && \
    ush/build_lapack.sh "$VER_lapack" 2>&1 | tee "$LOGDIR/log.lapack"

[[ $BUILD_boost  =~ [yYtT] ]] && \
    ush/build_boost.sh "$VER_boost" 2>&1 | tee "$LOGDIR/log.boost"

[[ $BUILD_eigen =~ [yYtT] ]] && \
    ush/build_eigen.sh "$VER_eigen" 2>&1 | tee "$LOGDIR/log.eigen"

[[ $BUILD_fftw  =~ [yYtT] ]] && \
    ush/build_fftw.sh "$VER_fftw" 2>&1 | tee "$LOGDIR/log.fftw"

[[ $BUILD_hdf5  =~ [yYtT] ]] && \
    ush/build_hdf5.sh "$VER_hdf5" 2>&1 | tee "$LOGDIR/log.hdf5"

[[ $BUILD_netcdf =~ [yYtT] ]] && \
    ush/build_netcdf.sh "$VER_netcdf_c" "$VER_netcdf_f" "$VER_netcdf_cxx" 2>&1 | tee "$LOGDIR/log.netcdf"

[[ $BUILD_nccmp     =~ [yYtT] ]] && \
    ush/build_nccmp.sh "$VER_nccmp" 2>&1 | tee "$LOGDIR/log.nccmp"

# Now build MPI libraries
set +x
module load $MPI
set -x

[[ $BUILD_boost  =~ [yYtT] ]] && \
    ush/build_boost.sh "$VER_boost" 2>&1 | tee "$LOGDIR/log.boost-mpi"

[[ $BUILD_fftw  =~ [yYtT] ]] && \
    ush/build_fftw.sh "$VER_fftw" 2>&1 | tee "$LOGDIR/log.fftw-mpi"

[[ $BUILD_hdf5  =~ [yYtT] ]] && \
    ush/build_hdf5.sh "$VER_hdf5" 2>&1 | tee "$LOGDIR/log.hdf5-mpi"

[[ $BUILD_pnetcdf =~ [yYtT] ]] && \
    ush/build_pnetcdf.sh "$VER_pnetcdf" 2>&1 | tee "$LOGDIR/log.pnetcdf-mpi"

[[ $BUILD_netcdf =~ [yYtT] ]] && \
    ush/build_netcdf.sh "$VER_netcdf_c" "$VER_netcdf_f" "$VER_netcdf_cxx" 2>&1 | tee "$LOGDIR/log.netcdf-mpi"

exit 0
