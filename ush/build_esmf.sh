#!/bin/sh

set -ex

name="esmf"
version=$1

software="ESMF_$version"

compiler=${COMPILER:-"gnu-7.3.0"}
mpi=${MPI:-""}

set +x
source $MODULESHOME/init/sh
module load $(echo $compiler | sed 's/-/\//g')
module load $(echo $mpi | sed 's/-/\//g')
module load szip
module load hdf5
module load netcdf
module load udunits
module list
set -x

if [[ ! -z $mpi ]]; then
    if [[ $(echo $mpi | cut -d- -f1) = "openmpi" ]]; then
        export ESMF_COMM="openmpi"
    elif [[ $(echo $mpi | cut -d- -f1) = "mpich" ]]; then
        export ESMF_COMM="mpich3"
    fi
    export FC=mpif90
    export CC=mpicc
    export CXX=mpicxx
fi

export F9X=$FC
export FFLAGS="-fPIC"
export CFLAGS="-fPIC"
export CXXFLAGS="-fPIC"
export FCFLAGS="$FFLAGS"

export ESMF_F90COMPILER=$FC
export ESMF_CXXCOMPILER=$CXX

export ESMF_COMPILER="gfortran"
export ESMF_NETCDF="nc-config"

gitURL="https://git.code.sf.net/p/esmf/esmf.git"

cd ${PKGDIR:-"../pkg"}

[[ -d $software ]] || ( git clone -b $software $gitURL $software )
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
export ESMF_DIR=$PWD

prefix="$PREFIX/$compiler/$mpi/$name/$version"
[[ -d $prefix ]] && ( echo "$prefix exists, ABORT!"; exit 1 )
export ESMF_INSTALL_PREFIX=$prefix

make -j${NTHREADS:-4}
make install
[[ "$CHECK" = "YES" ]] && make installcheck

[[ -z $mpi ]] && hierarchy="compiler" || hierarchy="mpi"
$STACKROOT/ush/deploy_module.sh $hierarchy $name $version

exit 0
