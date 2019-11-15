#!/bin/sh

set -ex

name="ecbuild"
srcver=$1

gitFork=$(echo $srcver | cut -d: -f1)
version=$(echo $srcver | cut -d: -f2)

software=$name-$gitFork-$version

gitURL="https://github.com/$gitFork/$name.git"

cd ${PKGDIR:-"../pkg"}

[[ -d $software ]] || ( git clone -b $version $gitURL $software )
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
[[ -d build ]] && rm -rf build
mkdir -p build && cd build

prefix="$PREFIX/$name/$gitFork-$version"
[[ -d $prefix ]] && ( echo "$prefix exists, ABORT!"; exit 1 )

cmake -DCMAKE_INSTALL_PREFIX=$prefix ..

make -j${NTHREADS:-4}
[[ "$CHECK" = "YES" ]] && ctest
make install

$STACKROOT/ush/deploy_module.sh "core" $name $gitFork-$version

exit 0
