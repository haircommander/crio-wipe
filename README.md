# crio-wipe

crio-wipe is a program that reads CRI-O's version file, and compares it to the output of crio --version.
If the version is deemed old enough, crio-wipe wipes container storage on the node.

crio-wipe assumes:
* the containers storage directory is `/var/lib/containers`
* the location of the version file is `/var/lib/crio/version`
* formatting of `crio --version` resembles `crio version $MAJOR.$MINOR...`
* formatting of version file resembles `"$MAJOR.$MINOR...`

if any of these things change, so must crio-wipe.  

crio-wipe has a test suite that can be run with `test.sh`. If it only outputs whitespace, it is passing.
