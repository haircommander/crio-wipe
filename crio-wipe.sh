#!/bin/sh
source $(dirname $0)/lib.sh
source $(dirname $0)/config.sh

success=$(main)
if [[ ! -z "$success" ]]; then
    echo "$success"
    exit 1
fi
