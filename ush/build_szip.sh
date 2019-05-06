#!/bin/sh

set -ex

name="szip"
version=$1

software=$name-$version

compiler=${COMPILER:-"gnu-7.3.0"}

set +x
source $MODULESHOME/init/sh
module load $(echo $compiler | sed 's/-/\//g')
module list
set -x

export CFLAGS="-fPIC"
export CXXFLAGS="-fPIC"
export FCFLAGS="-fPIC"

url="https://support.hdfgroup.org/ftp/lib-external/$name/$version/src/$software.tar.gz"

cd ${PKGDIR:-"../pkg"}

[[ -d $software ]] || ( wget $url; tar -xf $software.tar.gz )
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
[[ -d build ]] && rm -rf build
mkdir -p build && cd build

prefix="$PREFIX/$compiler/$name/$version"
[[ -d $prefix ]] && ( echo "$prefix exists, ABORT!"; exit 1 )

../configure --prefix=$prefix

make -j${NTHREADS:-4}
[[ "$CHECK" = "YES" ]] && make check
make install

$STACKROOT/ush/deploy_module.sh "compiler" $name $version

exit 0
