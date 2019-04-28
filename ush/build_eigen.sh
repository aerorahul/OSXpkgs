#!/bin/sh

set -ex

name="eigen"
version=$1

software=$name-$version

gitURL="https://github.com/eigenteam/eigen-git-mirror.git"

cd ${PKGDIR:-"../pkg"}

[[ -d $software ]] || ( git clone -b "$version" $gitURL $software )
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
[[ -d build ]] && rm -rf build
mkdir -p build && cd build

prefix="$PREFIX/$name/$version"
[[ -d $prefix ]] && ( echo "$prefix exists, ABORT!"; exit 1 )

cmake .. -DCMAKE_INSTALL_PREFIX=$prefix
[[ "$CHECK" = "YES" ]] && ctest
make install

$STACKROOT/ush/deploy_module.sh "core" $name $version

exit 0
