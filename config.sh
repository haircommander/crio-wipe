#!/bin/sh

VERSION_FILE_LOCATION="/etc/crio/version"
CONTAINERS_STORAGE_DIR="/var/lib/containers"
NEW_VERSION=$(crio --version)
