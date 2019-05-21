#!/bin/sh
dir=$(dirname $0)
source $dir/lib.sh

cleanup() {
    rm $VERSION_FILE_LOCATION
}
set_version_file() {
    echo "$1" > $VERSION_FILE_LOCATION
}

VERSION_FILE_LOCATION="$dir"/version.tmp
CONTAINERS_STORAGE_DIR=""
NEW_VERSION="crio version 1.1.1"

# expect to upgrade with no version file
should_not_be_empty=$(main)
if [[ -z "$should_not_be_empty" ]]; then
    echo "Failed to upgrade with no version file"
    exit 1
fi

touch $VERSION_FILE_LOCATION
trap cleanup EXIT

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

TMP_STORAGE="$dir/tmp"
mkdir "$TMP_STORAGE"
CONTAINERS_STORAGE_DIR="$TMP_STORAGE"
NEW_VERSION="crio storage bad format"
should_not_be_empty=$(main)
if [[ -z "$should_not_be_empty" ]]; then
    echo "Failed to exit with bad major new version"
    exit 1
fi
if [[ ! -d "$TMP_STORAGE" ]]; then
    echo "Crio updated even though new crio major version was formatted improperly"
    exit 1
fi

NEW_VERSION="crio storage 1.bad minor format.11"
should_not_be_empty=$(main)
if [[ -z "$should_not_be_empty" ]]; then
    echo "Failed to exit with bad new minor version"
    exit 1
fi
if [[ ! -d "$TMP_STORAGE" ]]; then
    echo "Crio updated even though new crio minor version was formatted improperly"
    exit 1
fi


# expect to upgrade with faulty version file
set_version_file "bad format"
should_not_be_empty=$(main)
if [[ -z "$should_not_be_empty" ]]; then
    echo "Failed to upgrade major release"
    exit 1
fi

# expect to upgrade with faulty minor version in version file
set_version_file "1.x.14"
should_not_be_empty=$(main)
if [[ -z "$should_not_be_empty" ]]; then
    echo "Failed to upgrade major release"
    exit 1
fi

