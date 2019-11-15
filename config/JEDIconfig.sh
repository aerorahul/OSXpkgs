#!/bin/sh

set -e

# What JEDI software stack to build
export BUILD_ecbuild=Y
export BUILD_eckit=Y
export BUILD_fckit=Y
export BUILD_atlas=Y

# What version of JEDI software to build and from where; e.g. source:version
export VER_ecbuild="jcsda:develop"
export VER_eckit="jcsda:develop"
export VER_fckit="jcsda:develop"
export VER_atlas="ecmwf:develop"
