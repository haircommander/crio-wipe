#!/bin/sh

get_major() {
    echo $@ | grep -Po '(?<=^crio version )\d(?=\.\d+\..*)'
}

get_minor() {
    echo $@ | grep -Po '(?<=^crio version \d\.)\d+(?=\..*)'
}

perform_wipe() {
    echo "I am wiping storage!"
    # rm -rf /var/lib/containers
    exit 1
}

check_versions_wipe_if_necessary() {
    # $1 should be the old version
    # $2 should be the new version

    # if we didn't find the old version. Our version file is invalid. Trigger wipe
    if [ -z "$1" ]; then
        echo "Version file invalid; wiping"
        perform_wipe
    fi

    # cast as integers to be used
    old=$(("$1" + 0))
    new=$(("$2" + 0))
    if [ $old -lt $new ]; then
        echo "New version detected; wiping"
        perform_wipe
    fi
}

VERSION_FILE_LOCATION="/etc/crio/version"
CONTAINERS_STORAGE_DIR="/var/lib/containers"

NEW_VERSION=$(crio --version)
NEW_MAJOR_VERSION=$(get_major $NEW_VERSION)
NEW_MINOR_VERSION=$(get_minor $NEW_VERSION)

if test -f $VERSION_FILE_LOCATION; then
    OLD_VERSION=$(cat $VERSION_FILE_LOCATION)
    OLD_MAJOR_VERSION=$(get_major $OLD_VERSION)
    MAJOR_CHECK=$(check_versions_wipe_if_necessary $OLD_MAJOR_VERSION $NEW_MAJOR_VERSION)
    if [[ ! -z "$MAJOR_CHECK" ]]; then
        echo "$MAJOR_CHECK"
        exit 1
    fi
    OLD_MINOR_VERSION=$(get_minor $OLD_VERSION)
    MINOR_CHECK=$(check_versions_wipe_if_necessary $OLD_MINOR_VERSION $NEW_MINOR_VERSION)
    if [[ ! -z "$MINOR_CHECK" ]]; then
        echo "$MAJOR_CHECK"
        exit 1
    fi
else
    perform_wipe
fi

