#!/bin/sh

set -ex

name="valgrind"
version=$1

software=$name-$version

compiler=${COMPILER:-"gnu-7.3.0"}
mpi=${MPI:-""}

set +x
source $MODULESHOME/init/sh
module load $(echo $compiler | sed 's/-/\//g')
module load $(echo $mpi | sed 's/-/\//g')
module list
set -x

export CFLAGS="-fPIC"
export CXXFLAGS="-fPIC"

url="https://sourceware.org/pub/valgrind/${software}.tar.bz2"

cd ${PKGDIR:-"../pkg"}

[[ -d $software ]] || ( wget $url ;  tar -xzf $software.tar.bz2 )
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
[[ -d build ]] && rm -rf build
mkdir -p build && cd build

prefix="$PREFIX/$compiler/$mpi/$name/$version"
[[ -d $prefix ]] && ( echo "$prefix exists, ABORT!"; exit 1 )

[[ -z $mpi ]] || extra_conf="--with-mpicc=$(which mpicc)"

../configure --prefix=$prefix $extra_conf

make -j${NTHREADS:-4}
[[ "$CHECK" = "YES" ]] && make check
make install

[[ -z $mpi ]] && hierarchy="compiler" || hierarchy="mpi"
$STACKROOT/ush/deploy_module.sh $hierarchy $name $version

exit 0
