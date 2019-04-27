#!/bin/sh

set -ex

# This script creates a modulefile for a given package
# based on a pre-existing template

# Arguments:
# $1 = hierarchyA = e.g. "core", "compiler", or "mpi"
# $2 = pkgName = package name
# $3 = pkgVersion = package version

hierarchyA=$1
pkgName=$2
pkgVersion=$3

case $hierarchyA in
    "core" )
        from_tmpl="$STACKROOT/modulefiles/core/$pkgName/$pkgName.lua.tmpl"
	    to_lua="$PREFIX/modulefiles/core/$pkgName/$pkgVersion.lua"
        ;;

    "compiler" )
        compiler=$(echo $COMPILER | sed 's/-/\//g')
        from_tmpl="$STACKROOT/modulefiles/compiler/compilerName/compilerVersion/$pkgName/$pkgName.lua.tmpl"
        to_lua="$PREFIX/modulefiles/compiler/$compiler/$pkgName/$pkgVersion.lua"
        ;;

    "mpi" )
        compiler=$(echo $COMPILER | sed 's/-/\//g')
        mpi=$(echo $MPI | sed 's/-/\//g')
        from_tmpl="$STACKROOT/modulefiles/mpi/compilerName/compilerVersion/mpiName/mpiVersion/$pkgName/$pkgName.lua.tmpl"
        to_lua="$PREFIX/modulefiles/mpi/$compiler/$mpi/$pkgName/$pkgVersion.lua"
        ;;

    * )
        echo "$hierarchyA is an invalid module hierarchy, ABORT!"
        exit 1
        ;;
esac

[[ -f $from_tmpl ]] || ( echo "$from_tmpl does not exist, ABORT!"; exit 1 )

mkdir -p $(dirname $to_lua)
cp $from_tmpl $to_lua

exit 0
