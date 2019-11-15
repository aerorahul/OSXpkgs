#!/bin/sh

set -e

export STACKROOT=$(pwd)

# Source configuration options
config=${1:-"$STACKROOT/config/config.sh"}
source $config
JEDIconfig=${1:-"$STACKROOT/config/JEDIconfig.sh"}
source $JEDIconfig

set -x

[[ $BUILD_ecbuild =~ [yYtT] ]] && \
    $STACKROOT/ush/build_ecbuild.sh "$VER_ecbuild" 2>&1 | tee "$LOGDIR/log.ecbuild"

[[ $BUILD_eckit =~ [yYtT] ]] && \
    $STACKROOT/ush/build_eckit.sh "$VER_eckit" 2>&1 | tee "$LOGDIR/log.eckit"

[[ $BUILD_fckit =~ [yYtT] ]] && \
    $STACKROOT/ush/build_fckit.sh "$VER_fckit" 2>&1 | tee "$LOGDIR/log.fckit"

[[ $BUILD_atlas =~ [yYtT] ]] && \
    $STACKROOT/ush/build_atlas.sh "$VER_atlas" 2>&1 | tee "$LOGDIR/log.atlas"

exit 0
