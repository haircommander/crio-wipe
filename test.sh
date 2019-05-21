#!/bin/sh
dir=$(dirname $0)
source $dir/lib.sh

VERSION_FILE_LOCATION="$dir"/version.tmp
CONTAINERS_STORAGE_DIR=""

touch $VERSION_FILE_LOCATION
cleanup() {
    rm $VERSION_FILE_LOCATION
}
trap cleanup EXIT


set_version_file() {
    echo "$1" > $VERSION_FILE_LOCATION
}
set_version_file "1.13.1"

# expect to not upgrade
NEW_VERSION="crio version 1.13.1"
should_be_empty=$(main)
echo "$should_be_empty"

# expect to not upgrade for sub-minor releases
NEW_VERSION="crio version 1.13.2"
should_be_empty=$(main)
echo "$should_be_empty"

# expect to upgrade for minor release
NEW_VERSION="crio version 1.14.0"
should_not_be_empty=$(main)
if [[ -z "$should_not_be_empty" ]]; then
    echo "Failed to upgrade minor release"
    exit 1
fi

# expect to upgrade for major release
NEW_VERSION="2.0.0"
should_not_be_empty=$(main)
if [[ -z "$should_not_be_empty" ]]; then
    echo "Failed to upgrade major release"
    exit 1
fi
