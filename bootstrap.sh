#!/bin/bash

# Installs the tools on a Ubuntu 14.04 OS to enable it to be provisioned by the puppet manifests in the devhost project.

trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

PUPPET_VERSION=3.7.3-1
PHING_VERSION=2.7.0
TESTING=$(trim $1)

echo "TESTING='${TESTING}'"

add-apt-repository multiverse
apt-get update

### Install required tools
apt-get install -y wget git php-pear bundler
PEAR_OK=$(command -v pear)
if [ "" == "$PEAR_OK" ]; then
	echo "Pear not installed. Installing."
	pear channel-discover pear.phing.info
	pear install phing/phing-${PHING_VERSION}
else 
	echo -e "Pear already install:\n ${PEAR_OK}"
	pear version
fi 

### Install puppet
PUPPET_OK=$(dpkg-query -l puppet | grep puppet)
if [ "" == "$PUPPET_OK" ]; then
	echo "Puppet not installed. Installing."
	wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
	dpkg -i puppetlabs-release-trusty.deb
	apt-get update
	apt-get install -yq puppet-common=${PUPPET_VERSION}puppetlabs1 puppet=${PUPPET_VERSION}puppetlabs1 
else 
	echo -e "Puppet already installed:\n ${PUPPET_OK}"
	puppet --version
fi 

# Install librarian puppet. Requires bundler package.
LIBPUP_OK=$(command -v librarian-puppet)
if [ "" == "$LIBPUP_OK" ]; then
	gem install librarian-puppet -v 1.3.2 --source 'https://rubygems.org'
else 
	echo -e "librarian-puppet already installed:\n ${LIBPUP_OK}"
	librarian-puppet version
fi 

curl -O https://raw.githubusercontent.com/mtbvang/devhost/master/Puppetfile

if [ ! -f Puppetfile.lock ]; then
	echo "No librarian-puppet lock file found. Installing."
	librarian-puppet install --verbose
else
	echo "librarian-puppet lock file found. Updating."
	librarian-puppet update --verbose
fi

### Provision
# If TESTING argument not supplied then clone and use manifests from github. Otherwise use local manifests.
if [ "$TESTING" == "" ]; then	
	# Clone devhost repository
	if [[ ! -e "modules/devhost" ]]; then
		echo "Cloning repo..."
		git clone https://github.com/mtbvang/puppet-devhost.git modules/devhost
	elif [[ ! -d $dir ]]; then
	    echo "Not cloning devhost repo, devhost folder already exists."
	fi
else 
	if [ "$TESTING" == "local" ]; then	
		echo "Test run using local manifests files. Copying local files to modules/devhost."			
		# TODO copy files to modules folder
		mkdir -p modules/devhost
		cp -rf files modules/devhost/files
		cp -rf manifests modules/devhost/manifests
	else
		echo "Invalid argument supplied: '$1'."
		echo "Script takes one argument that can be set to 'local' for testing."
		echo "Exiting"
		exit 1
	fi
fi

puppet apply --summarize --modulepath=modules modules/devhost/manifests/default.pp

# Only clean up if not locally testing.
if [ "$TESTING" == "" ]; then
	rm -rf modules
fi

# Reset password
passwd dev