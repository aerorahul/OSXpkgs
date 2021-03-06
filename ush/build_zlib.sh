#!/bin/sh

set -ex

name="zlib"
version=$1

software=$name-$version

compiler=${COMPILER:-"gnu-7.3.0"}

set +x
source $MODULESHOME/init/sh
module load $(echo $compiler | sed 's/-/\//g')
module list
set -x

export FCFLAGS="-fPIC"
export CFLAGS="-fPIC"
export CXXFLAGS="-fPIC"

cd ${PKGDIR:-"../pkg"}

url=http://www.zlib.net/fossils/$software.tar.gz

[[ -d $software ]] && rm -rf $software
[[ -d $software ]] || ( wget $url; tar -xf $software.tar.gz )
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )

prefix="$PREFIX/$compiler/$name/$version"
[[ -d $prefix ]] && ( echo "$prefix exists, ABORT!"; exit 1 )

configure --prefix=$prefix

make -j${NTHREADS:-4}
[[ "$CHECK" = "YES" ]] && make check
make install

$STACKROOT/ush/deploy_module.sh "compiler" $name $version

exit 0
