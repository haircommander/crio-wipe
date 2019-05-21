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

