#!/bin/bash

PUPPET_VERSION=$1

# Install puppet
add-apt-repository multiverse
apt-get install -yq wget dialog

### Install puppet
PUPPET_OK=$(dpkg-query -l puppet | grep ${PUPPET_VERSION}puppetlabs1)
if [ "" == "$PUPPET_OK" ]; then
	echo "Puppet not installed. Installing."
	wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
	dpkg -i puppetlabs-release-trusty.deb
	apt-get update
	apt-get install -yq puppet-common=${PUPPET_VERSION}puppetlabs1 puppet=${PUPPET_VERSION}puppetlabs1
	echo "sudo puppet apply --modulepath=/vagrant_data/modules /vagrant_data/manifests/site.pp " > /usr/local/bin/runpuppet
	chmod 755 /usr/local/bin/runpuppet
	echo "sudo puppet apply --modulepath=/vagrant_data/modules -e \"include '\$1'\"" > /usr/local/bin/runpuppetclass
	chmod 755 /usr/local/bin/runpuppetclass
else 
	echo -e "Puppet already install:\n ${PUPPET_OK}"
	puppet --version
fi 

# Ensure build dir exists.
mkdir -p /vagrant/build

# Run librarian puppet
cd /vagrant
echo "pwd: $(pwd)"
librarian-puppet update --verbose

# TODO copy files to modules folder
mkdir -p modules/devhost
cp -rf files modules/devhost/files
cp -rf manifests modules/devhost/manifests