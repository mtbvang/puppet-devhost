#!/bin/bash

# Installs the tools on a Ubuntu 14.04 OS to enable it to be provisioned by the puppet manifests in the devhost project.

trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

PUPPET_VERSION=3.7.3-1

add-apt-repository multiverse
apt-get update

### Install required tools
apt-get install -yq wget git bundler ruby-dev libxml2-dev libxslt1-dev g++
# Install beaker
BEAKER_OK=$(gem list | grep beaker)
if [ "" == "$BEAKER_OK" ]; then
	echo "beaker gem not installed. Installing."
	gem install beaker
else 
	echo -e "beaker gem already install:\n ${BEAKER_OK}"
fi 

# Install beaker-librarian
BEAKER_LIB_OK=$(gem list | grep beaker-librarian)
if [ "" == "$BEAKER_LIB_OK" ]; then
	echo "beaker-librarian gem not installed. Installing."
	gem install beaker-librarian
else 
	echo -e "beaker-librarian gem already install:\n ${BEAKER_LIB_OK}"
fi 