#!/usr/bin/env bash

cd "$(dirname "$0")"

# turn on verbose debugging output for parabuild logs.
exec 4>&1; export BASH_XTRACEFD=4; set -x

# make errors fatal
set -e

# complain about unreferenced environment variables
set -u

if [ -z "$AUTOBUILD" ] ; then
    exit 1
fi

if [ "$OSTYPE" = "cygwin" ] ; then
    autobuild="$(cygpath -u $AUTOBUILD)"
else
    autobuild="$AUTOBUILD"
fi

top="$(pwd)"
stage="$top/stage"

# load autobuild provided shell functions and variables
source_environment_tempfile="$stage/source_environment.sh"
"$autobuild" source_environment > "$source_environment_tempfile"
. "$source_environment_tempfile"

XXHASH_SOURCE_DIR="xxHash-release"

version="0.8.1"

build=${AUTOBUILD_BUILD_ID:=0}
echo "${version}.${build}" > "${stage}/VERSION.txt"

pushd "$XXHASH_SOURCE_DIR"
    case "$AUTOBUILD_PLATFORM" in

        windows*)
            mkdir -p "$stage/include/xxhash"
            cp -a xxhash.h "$stage/include/xxhash/xxhash.h"
        ;;

        darwin*)
            mkdir -p "$stage/include/xxhash"
            cp -a xxhash.h "$stage/include/xxhash/xxhash.h"
        ;;

        linux*)
            mkdir -p "$stage/include/xxhash"
            cp -a xxhash.h "$stage/include/xxhash/xxhash.h"
        ;;
    esac
    mkdir -p "$stage/LICENSES"
    cp -a LICENSE "$stage/LICENSES/xxhash.txt"
popd
