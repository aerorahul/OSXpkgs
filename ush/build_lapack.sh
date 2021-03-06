#!/bin/sh

set -ex

name="lapack"
version=$1

software=$name-$version

# Hyphenated version used for install prefix
compiler=$(echo $COMPILER | sed 's/\//-/g')

set +x
source $MODULESHOME/init/sh
module load $(echo $compiler | sed 's/-/\//g')
module list
set -x

export CFLAGS="-fPIC"
export CXXFLAGS="-fPIC"
export FCFLAGS="-fPIC"

url="http://www.netlib.org/lapack/$software.tar.gz"

cd ${PKGDIR:-"../pkg"}

[[ -d $software ]] || ( wget $url; tar -xf $software.tar.gz )
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
[[ -d build ]] && rm -rf build
mkdir -p build && cd build

prefix="$PREFIX/$compiler/$name/$version"
[[ -d $prefix ]] && ( echo "WARNING: $prefix EXISTS, ABORT!"; exit 1 )

# Add CMAKE_INSTALL_LIBDIR to make sure it will be installed under lib not lib64
cmake \
    -DCMAKE_INSTALL_PREFIX=$prefix \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_LIBDIR:PATH=$prefix/lib \
    -DCMAKE_Fortran_COMPILER=$FC \
    -DCMAKE_Fortran_FLAGS=$FCFLAGS \
    ..

make -j${NTHREADS:-4}
[[ $CHECK = "YES" ]] && make check
make install

$STACKROOT/ush/deploy_module.sh "compiler" $name $version

exit 0
