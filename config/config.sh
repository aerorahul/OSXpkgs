#!/bin/sh

set -e

# Where do you want to Install packages to?
export PREFIX="${HOME}/opt"

# Where do you want to download and build packages into?
export PKGDIR="${STACKROOT}/pkg"
export LOGDIR="${STACKROOT}/pkg"

# Do you wish to check for built packages via make check or ctest?
export CHECK=N

# Compiler and MPI families
export FAMILY_COMPILER="gnu"
export FAMILY_MPI="openmpi"

# What to build; compiler and mpi
export BUILD_COMPILER="setup-module"  # OPTIONS: native-module | setup-module | from-source
#export BUILD_MPI="from-source"         # OPTIONS: native-module | setup-module | from-source

# What to build; stack
export BUILD_szip=Y
export BUILD_zlib=Y
export BUILD_fftw=Y
export BUILD_udunits=Y
export BUILD_hdf5=Y
export BUILD_pnetcdf=Y
export BUILD_netcdf=Y
export BUILD_nccmp=Y
export BUILD_lapack=Y
export BUILD_boost=Y
export BUILD_eigen=Y
export BUILD_esmf=Y
export BUILD_baselibs=Y
export BUILD_ecbuild=Y
export BUILD_eckit=Y
export BUILD_fckit=Y
export BUILD_eccodes=Y


# What version of software to build
export VER_gnu="9.1.0"
export VER_clang="10.0.1"
export VER_openmpi="3.1.2"
export VER_mpich="3.2.1"
export VER_szip="2.1.1"
export VER_zlib="1.2.8"
export VER_fftw="3.3.8"
export VER_udunits="2.2.26"
export VER_hdf5="1_10_3"
export VER_pnetcdf="1.11.1"
export VER_netcdf_c="4.6.1"
export VER_netcdf_f="4.4.4"
export VER_netcdf_cxx="4.3.0"
export VER_nccmp="1.8.2.1"
export VER_lapack="3.8.0"
export VER_boost="1.68.0"
export VER_eigen="3.3.5"
export VER_esmf="7_1_0r"
export VER_baselibs="5.2.2"
export VER_ecbuild="release-stable"
export VER_eckit="1.4.0"
export VER_fckit="develop"
export VER_eccodes="2.8.2"

################################################################################
# End of Manual Configuration
################################################################################

# Nothing below needs changing, unless you know what you are doing
export OPT=$PREFIX

# Construct COMPILER and MPI variables based on choices made above
export COMPILER=$(eval echo $(eval echo \${FAMILY_COMPILER}-\${VER_${FAMILY_COMPILER}}))
export MPI=$(eval echo $(eval echo \${FAMILY_MPI}-\${VER_${FAMILY_MPI}}))
