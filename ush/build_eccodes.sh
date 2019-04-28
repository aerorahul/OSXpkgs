#!/bin/sh

set -ex

name="eccodes"
version=$1

software=$name-$version

compiler=${COMPILER:-"gnu-7.3.0"}

set +x
source $MODULESHOME/init/sh
module load $(echo $compiler | sed 's/-/\//g')
module load szip
module load hdf5
module load netcdf
module list
set -x

export FCFLAGS="-fPIC"
export CFLAGS="-fPIC"
export CXXFLAGS="-fPIC"

gitURL="https://github.com/ecmwf/eccodes.git"

cd ${PKGDIR:-"../pkg"}

[[ -d $software ]] || ( git clone -b $version $gitURL $software )
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
[[ -d build ]] && rm -rf build
mkdir -p build && cd build

prefix="$PREFIX/$compiler/$name/$version"
[[ -d $prefix ]] && ( echo "$prefix exists, ABORT!"; exit 1 )

cmake -DCMAKE_INSTALL_PREFIX=$prefix -DENABLE_NETCDF=ON -DENABLE_FORTRAN=ON ..

make -j${NTHREADS:-4}
[[ "$CHECK" = "YES" ]] && ctest
make install

$STACKROOT/ush/deploy_module.sh "compiler" $name $version

exit 0
