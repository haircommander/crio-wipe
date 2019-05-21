#!/bin/bash

get_major() {
    echo $@ | grep -Po '^(crio version )?\K\d(?=\.\d+\..*)'
}

get_minor() {
    echo $@ | grep -Po '^(crio version )?\d\.\K\d+(?=\..*)'
}

perform_wipe() {
    echo "I am wiping storage!"
    # rm -rf /var/lib/containers
    exit 1
}

check_versions_wipe_if_necessary() {
    # $1 should be the new version
    # $2 should be the old version

    # if we didn't find the old version. Our version file is invalid. Trigger wipe
    if [ -z "$2" ]; then
        echo "Version file invalid; wiping"
        perform_wipe
    fi

    # cast as integers to be used
    new=$(("$1" + 0))
    old=$(("$2" + 0))
    if [ $old -lt $new ]; then
        echo "New version detected; wiping"
        perform_wipe
    fi
}

main() {
    NEW_MAJOR_VERSION=$(get_major $NEW_VERSION)
    if [[ -z "$NEW_MAJOR_VERSION" ]]; then
        echo "New major version not set"
        exit 1
    fi
    NEW_MINOR_VERSION=$(get_minor $NEW_VERSION)
    if [[ -z "$NEW_MINOR_VERSION" ]]; then
        echo "New minor version not set"
        exit 1
    fi

    if test -f $VERSION_FILE_LOCATION; then
        OLD_VERSION=$(cat $VERSION_FILE_LOCATION)
        OLD_MAJOR_VERSION=$(get_major $OLD_VERSION)
        MAJOR_CHECK=$(check_versions_wipe_if_necessary $NEW_MAJOR_VERSION $OLD_MAJOR_VERSION)
        if [[ ! -z "$MAJOR_CHECK" ]]; then
            echo "major $MAJOR_CHECK"
            exit 1
        fi
        OLD_MINOR_VERSION=$(get_minor $OLD_VERSION)
        MINOR_CHECK=$(check_versions_wipe_if_necessary $NEW_MINOR_VERSION $OLD_MINOR_VERSION)
        if [[ ! -z "$MINOR_CHECK" ]]; then
            echo "minor $MINOR_CHECK"
            exit 1
        fi
    else
        echo "old version not found"
        perform_wipe
    fi
}
