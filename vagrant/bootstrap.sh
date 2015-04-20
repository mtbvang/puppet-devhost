#!/bin/bash

PUPPET_VERSION=$1
FORCEK_PUPPET=$2

# Lubuntu doesn't come wiht add-apt-repository so install it first.
apt-get install -yq software-properties-common
add-apt-repository multiverse
apt-get update
apt-get install -yq wget dialog rubygems-integration git

### Install puppet
PUPPET_OK=$(dpkg-query -l puppet | grep ${PUPPET_VERSION}puppetlabs1)
if [ "" == "$PUPPET_OK" ] || [ "$FORCEK_PUPPET" = "true" ]; then
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

# Run librarian puppet to get all required dependencies
cd /vagrant
echo "pwd: $(pwd)"
gem install librarian-puppet
librarian-puppet update --verbose

# Copy devhost files to modules folder so puppet gets access
mkdir -p modules/devhost
cp -rf files modules/devhost
cp -rf manifests modules/devhost