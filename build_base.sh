#!/bin/sh

set -e

export STACKROOT=$(pwd)

# Source configuration options
config=${1:-"config/config.sh"}
source $config

set -x

# First determine if COMPILER needs to be built or loaded
case ${BUILD_COMPILER} in
    "native-module")
        echo "USING NATIVE COMPILER MODULE"
        module load $COMPILER
        ;;
    "setup-module")
        echo "SETTING UP A MODULEFILE FOR $COMPILER"
        pkgName=$(echo $COMPILER | cut -d- -f1)
        pkgVersion=$(echo $COMPILER | cut -d- -f2)
        ush/deploy_module.sh "core" "$pkgName" "$pkgVersion"
        ;;
    "from-source")
        echo "BUILD COMPILER FROM SOURCE"
        if [[ ${FAMILY_COMPILER} =~ "gnu" ]]; then
            ush/build_gnu.sh "$COMPILER" 2>&1 | tee "$LOGDIR/log.gnu"
        else
            echo "ERROR: COMPILER $COMPILER NOT FOUND: ABORT!"
            exit 1
        fi
        ;;
    *)
        echo "ERROR: UNKNOWN OPTION FOR BUILD_COMPILER = ${BUILD_COMPILER}: ABORT!"
        exit 1
        ;;
esac

# Next determine if MPI needs to be built or loaded
case ${BUILD_MPI} in
    "native-module")
        echo "USING NATIVE MPI MODULE"
        module load $COMPILER
        module load $MPI
        ;;
    "setup-module")
        echo "SETTING UP A MODULEFILE FOR $MPI"
        pkgName=$(echo $MPI | cut -d- -f1)
        pkgVersion=$(echo $MPI | cut -d- -f2)
        ush/deploy_module.sh "compiler" "$pkgName" "$pkgVersion"
        ;;
    "from-source")
        echo "BUILD MPI FROM SOURCE"
        ush/build_szip.sh "$VER_szip" 2>&1 | tee "$LOGDIR/log.szip"
        ush/build_mpi.sh "$MPI" 2>&1 | tee "$LOGDIR/log.$MPI"
        ;;
    *)
        echo "ERROR: UNKNOWN OPTION FOR BUILD_MPI = ${BUILD_MPI}: ABORT!"
        exit 1
        ;;
esac

exit 0
