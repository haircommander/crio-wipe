# crio-wipe

crio-wipe is a program that reads CRI-O's version file, and compares it to the output of crio --version.
If the version is deemed old enough, crio-wipe wipes container storage on the node.

crio-wipe assumes:
* the containers storage directory is /var/lib/containers
* the location of the version file is /var/lib/crio/version
* quite a bit about the format of crio --version and the version file

if any of these things change, so must crio-wipe
