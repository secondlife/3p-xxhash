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

XXHASH_SOURCE_DIR="$top/xxHash"

line1="$(head -n 1 "$XXHASH_SOURCE_DIR/cli/xxhsum.1")"
if [[ "$line1" =~ '"xxhsum '([[:digit:]]+\.[[:digit:]]+\.[[:digit:]])'"' ]]
then version="${BASH_REMATCH[1]}"
else version="0.8.1"
fi

build=${AUTOBUILD_BUILD_ID:=0}
echo "${version}-${build}" > "${stage}/VERSION.txt"

pushd "$XXHASH_SOURCE_DIR"
    mkdir -p "$stage/include/xxhash"
    cp -a xxhash.h "$stage/include/xxhash/xxhash.h"
    mkdir -p "$stage/LICENSES"
    cp -a LICENSE "$stage/LICENSES/xxhash.txt"
popd
