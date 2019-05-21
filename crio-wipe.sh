#!/bin/sh
dir=${0%/*}
source "$dir/lib.sh"
source "$dir/config.sh"

success=$(main)
if [[ ! -z "$success" ]]; then
    echo "$success"
    exit 1
fi
