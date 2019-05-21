#!/bin/sh
source $(dirname $0)/lib.sh
source $(dirname $0)/config.sh

NEW_MAJOR_VERSION=$(get_major $NEW_VERSION)
NEW_MINOR_VERSION=$(get_minor $NEW_VERSION)

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
        echo "minor $MAJOR_CHECK"
        exit 1
    fi
else
    perform_wipe
fi
