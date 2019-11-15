#!/bin/sh

set -e

export STACKROOT=$(pwd)

# Source configuration options
config=${1:-"$STACKROOT/config/config.sh"}
source $config

set -x

#First nullify MPI variable for serial build
MPI_=$MPI ; export MPI=""

# Build COMPILER libraries
[[ $BUILD_zlib =~ [yYtT] ]] && \
    $STACKROOT/ush/build_zlib.sh "$VER_zlib" 2>&1 | tee "$LOGDIR/log.zlib"

[[ $BUILD_szip =~ [yYtT] ]] && \
    $STACKROOT/ush/build_szip.sh "$VER_szip" 2>&1 | tee "$LOGDIR/log.szip"

[[ $BUILD_udunits =~ [yYtT] ]] && \
    $STACKROOT/ush/build_udunits.sh "$VER_udunits" 2>&1 | tee "$LOGDIR/log.udunits"

[[ $BUILD_lapack =~ [yYtT] ]] && \
    $STACKROOT/ush/build_lapack.sh "$VER_lapack" 2>&1 | tee "$LOGDIR/log.lapack"

[[ $BUILD_boost  =~ [yYtT] ]] && \
    $STACKROOT/ush/build_boost.sh "$VER_boost" 2>&1 | tee "$LOGDIR/log.boost"

[[ $BUILD_eigen =~ [yYtT] ]] && \
    $STACKROOT/ush/build_eigen.sh "$VER_eigen" 2>&1 | tee "$LOGDIR/log.eigen"

[[ $BUILD_fftw  =~ [yYtT] ]] && \
    $STACKROOT/ush/build_fftw.sh "$VER_fftw" 2>&1 | tee "$LOGDIR/log.fftw"

[[ $BUILD_hdf5  =~ [yYtT] ]] && \
    $STACKROOT/ush/build_hdf5.sh "$VER_hdf5" 2>&1 | tee "$LOGDIR/log.hdf5"

[[ $BUILD_netcdf =~ [yYtT] ]] && \
    $STACKROOT/ush/build_netcdf.sh "$VER_netcdf_c" "$VER_netcdf_f" "$VER_netcdf_cxx" 2>&1 | tee "$LOGDIR/log.netcdf"

[[ $BUILD_nccmp =~ [yYtT] ]] && \
    $STACKROOT/ush/build_nccmp.sh "$VER_nccmp" 2>&1 | tee "$LOGDIR/log.nccmp"

[[ $BUILD_cgal =~ [yYtT] ]] && \
    $STACKROOT/ush/build_cgal.sh "$VER_cgal" 2>&1 | tee "$LOGDIR/log.cgal"

# Now build MPI libraries
export MPI=$MPI_; unset MPI_

[[ $BUILD_boost  =~ [yYtT] ]] && \
    $STACKROOT/ush/build_boost.sh "$VER_boost" 2>&1 | tee "$LOGDIR/log.boost-mpi"

[[ $BUILD_fftw  =~ [yYtT] ]] && \
    $STACKROOT/ush/build_fftw.sh "$VER_fftw" 2>&1 | tee "$LOGDIR/log.fftw-mpi"

[[ $BUILD_hdf5  =~ [yYtT] ]] && \
    $STACKROOT/ush/build_hdf5.sh "$VER_hdf5" 2>&1 | tee "$LOGDIR/log.hdf5-mpi"

[[ $BUILD_pnetcdf =~ [yYtT] ]] && \
    $STACKROOT/ush/build_pnetcdf.sh "$VER_pnetcdf" 2>&1 | tee "$LOGDIR/log.pnetcdf-mpi"

[[ $BUILD_netcdf =~ [yYtT] ]] && \
    $STACKROOT/ush/build_netcdf.sh "$VER_netcdf_c" "$VER_netcdf_f" "$VER_netcdf_cxx" 2>&1 | tee "$LOGDIR/log.netcdf-mpi"

[[ $BUILD_esmf =~ [yYtT] ]] && \
    $STACKROOT/ush/build_esmf.sh "$VER_esmf" 2>&1 | tee "$LOGDIR/log.esmf-mpi"

exit 0
