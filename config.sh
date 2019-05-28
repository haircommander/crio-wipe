#!/bin/sh

VERSION_FILE_LOCATION="/var/lib/crio/version"
CONTAINERS_STORAGE_DIR="/var/lib/containers"
NEW_VERSION=$(crio --version)
WIPE=0
