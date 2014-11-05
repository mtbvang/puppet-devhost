#!/bin/bash

PUPPET_VERSION=$1

# Install puppet
add-apt-repository multiverse
apt-get install -yq wget dialog
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
apt-get update
apt-get install -yq puppet-common=${PUPPET_VERSION}puppetlabs1 puppet=${PUPPET_VERSION}puppetlabs1 php-pear
echo "sudo puppet apply --modulepath=/vagrant_data/modules /vagrant_data/manifests/site.pp " > /usr/local/bin/runpuppet
chmod 755 /usr/local/bin/runpuppet
echo "sudo puppet apply --modulepath=/vagrant_data/modules -e \"include '\$1'\"" > /usr/local/bin/runpuppetclass
chmod 755 /usr/local/bin/runpuppetclass

rm -rf /var/lib/puppet/state/graphs
ln -sf /vagrant/build /var/lib/puppet/state/graphs



