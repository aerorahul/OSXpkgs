#!/bin/sh

set -ex

name="cgal"
version=$1

software="CGAL-$version"

compiler=${COMPILER:-"gnu-7.4.0"}

set +x
source $MODULESHOME/init/sh
module load $(echo $compiler | sed 's/-/\//g')
module load zlib
module load boost
module list
set -x

export FFLAGS="-fPIC"
export CFLAGS="-fPIC"
export CXXFLAGS="-fPIC"

cd ${PKGDIR:-"../pkg"}

url="https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-$version/$software-library.tar.xz"

[[ -d $software ]] || ( wget $url; tar -xf $software-library.tar.xz )
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
[[ -d build ]] && rm -rf build
mkdir -p build && cd build

prefix="$PREFIX/$compiler/$name/$version"
[[ -d $prefix ]] && ( echo "$prefix exists, ABORT!"; exit 1 )

cmake -DCMAKE_INSTALL_PREFIX=$prefix ..
make -j${NTHREADS:-4}
[[ "$CHECK" = "YES" ]] && make check
make install

hierarchy="compiler"
$STACKROOT/ush/deploy_module.sh $hierarchy $name $version

exit 0
