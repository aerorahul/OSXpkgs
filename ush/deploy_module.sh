#!/bin/sh

set -ex

# Create a modulefile for a given version
# based on the generic modulefile for that package.

# Arguments:
# $1 = hierarchyA = e.g. "core", "compiler", or "mpi"
# $2 = pkgName = package name
# $3 = pkgVersion = package version

hierarchyA=$1
pkgName=$2
pkgVersion=$3

case $hierarchyA in
    "core" )
        from_lua="$STACKROOT/modulefiles/core/$pkgName/$pkgName.lua"
        to_lua="$PREFIX/modulefiles/core/$pkgName/$pkgVersion.lua"
        ;;

    "compiler" )
        compiler=$(echo $COMPILER | sed 's/-/\//g')
        from_lua="$STACKROOT/modulefiles/compiler/compilerName/compilerVersion/$pkgName/$pkgName.lua"
        to_lua="$PREFIX/modulefiles/compiler/$compiler/$pkgName/$pkgVersion.lua"
        ;;

    "mpi" )
        compiler=$(echo $COMPILER | sed 's/-/\//g')
        mpi=$(echo $MPI | sed 's/-/\//g')
        from_lua="$STACKROOT/modulefiles/mpi/compilerName/compilerVersion/mpiName/mpiVersion/$pkgName/$pkgName.lua"
        to_lua="$PREFIX/modulefiles/mpi/$compiler/$mpi/$pkgName/$pkgVersion.lua"
        ;;

    * )
        echo "$hierarchyA is an invalid module hierarchy, ABORT!"
        exit 1
        ;;
esac

[[ -f $from_lua ]] || ( echo "$from_lua does not exist, ABORT!"; exit 1 )

mkdir -p $(dirname $to_lua)
cp $from_lua $to_lua

exit 0
