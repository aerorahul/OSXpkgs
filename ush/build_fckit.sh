#!/bin/sh

set -ex

name="fckit"
version=$1
gitFork=${2:-"jcsda"}

software=$name-$gitFork-$version

compiler=${COMPILER:-"gnu-7.3.0"}
mpi=${MPI:-""}

set +x
source $MODULESHOME/init/sh
module load $(echo $compiler | sed 's/-/\//g')
module load $(echo $mpi | sed 's/-/\//g')
module load szip
module load hdf5
module load netcdf
module load eigen
module load boost
module load eckit
module load ecbuild
module list
set -x

gitURL="https://github.com/$gitFork/$name.git"

cd ${PKGDIR:-"../pkg"}

[[ -d $software ]] || ( git clone -b $version $gitURL $software )
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
[[ -d build ]] && rm -rf build
mkdir -p build && cd build

prefix="$PREFIX/$compiler/$mpi/$name/$version"
[[ -d $prefix ]] && ( echo "$prefix exists, ABORT!"; exit 1 )

ecbuild --prefix=$prefix ..

make -j${NTHREADS:-4}
ctest
make install

[[ -z $mpi ]] && hierarchy="compiler" || hierarchy="mpi"
$STACKROOT/ush/deploy_module.sh $hierarchy $name $version

exit 0