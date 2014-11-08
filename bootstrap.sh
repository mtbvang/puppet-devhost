#!/bin/bash

# Installs the tools on a Ubuntu 14.04 OS to enable it to be provisioned by the puppet manifests in the devhost project.

PUPPET_VERSION=3.6.2-1
PHING_VERSION=2.7.0
add-apt-repository multiverse
apt-get update

# Install required tools
apt-get install -yq wget git php-pear
pear channel-discover pear.phing.info
pear install [--alldeps] phing/phing-${PHING_VERSION}

# Install puppet
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
apt-get update
apt-get install -yq puppet-common=${PUPPET_VERSION}puppetlabs1 puppet=${PUPPET_VERSION}puppetlabs1 

# Clone devhost repository
git clone https://github.com/mtbvang/devhost.git

