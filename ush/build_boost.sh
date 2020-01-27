#!/bin/sh

set -x

name="boost"
version=$1
HEADERS_ONLY=${2:-"YES"}

version_=$(echo $version | sed 's/\./_/g')
software=${name}_${version_}

compiler=${COMPILER:-"gnu-7.3.0"}
mpi=${MPI:-""}

debug="--debug-configuration"

set +x
source $MODULESHOME/init/sh
module load $(echo $compiler | sed 's/-/\//g')
module load $(echo $mpi | sed 's/-/\//g')
module list
set -x

url="https://dl.bintray.com/boostorg/release/$version/source/${software}.tar.gz"

cd ${PKGDIR:-"../pkg"}

[[ -d $software ]] || ( wget $url ; tar -xzf $software.tar.gz )
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )

BoostRoot=$(pwd)

if [[ $HEADERS_ONLY != "YES" ]]; then
  prefix="$PREFIX/$compiler/$mpi/$name/$version"
else
  prefix="$PREFIX/$name/$version"
fi
[[ -d $prefix ]] && ( echo "$prefix exists, ABORT!"; exit 1 )

mkdir -p $prefix $prefix/include

cd $BoostRoot

if [ "${HEADERS_ONLY}" != "YES" ]; then

    BoostBuild=$BoostRoot/BoostBuild
    build_boost=$BoostRoot/build_boost
    [[ -d $BoostBuild ]] && rm -rf $BoostBuild
    [[ -d $build_boost ]] && rm -rf $build_boost
    mkdir -p $BoostBuild $build_boost

    # Configure with MPI
    compName=$(echo $compiler | cut -d- -f1)
    case "$compName" in
        gnu   ) toolset=gcc ; MPICC=$(which mpicc) ;;
        intel ) toolset=intel MPICC=$(which mpiicc) ;;
        *     ) echo "Unknown compiler = $compName, ABORT!"; exit 1 ;;
    esac

    if [ ! -z $mpi ]; then

        cd $BoostRoot/tools/build
        cp $BoostRoot/tools/build/example/user-config.jam ./user-config.jam
        cat >> ./user-config.jam << EOF

        # ------------------
        # MPI configuration.
        # ------------------
        using mpi : $MPICC ;
EOF

        rm -f $HOME/user-config.jam
        mv -f ./user-config.jam $HOME

    fi

    cd $BoostRoot

    ./bootstrap.sh --with-toolset=$toolset
    ./b2 install $debug --prefix=$BoostBuild

    export PATH="$BoostBuild/bin:$PATH"

    cd $BoostRoot
    b2 $debug --build-dir=$build_boost address-model=64 toolset=$toolset stage

    rm -f $HOME/user-config.jam

    mv stage/lib $prefix

fi

cp -R boost $prefix/include

if [[ $HEADERS_ONLY != "YES" ]]; then
  [[ -z $mpi ]] && hierarchy="compiler" || hierarchy="mpi"
else
  hierarchy="core"
fi
$STACKROOT/ush/deploy_module.sh $hierarchy $name $version

exit 0
