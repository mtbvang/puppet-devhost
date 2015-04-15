#!/bin/bash

# Provisons a Ubuntu 14.04 64bit OS with the devhost module. You'll likely want to override the USER argument so that it doesn't install in the default dev user account.
#
# Arguments:
# 	1) USER 			string: Default 'dev' - Account to provision.
#	2) FORCE_PUPPET		boolean: Default 'true' - True forces re/install of puppet.
#	3) SRC_REPO 		string github|local: Default 'github' - Which devhost source files to use. Github downloads them from github. Local uses files in manifests dir.
#   4) PUPPET_VERSION 	string: Default 3.7.3-1 - Version number of Ubuntu puppet deb package.
#	5) PHING_VERSION	string: Default 2.8.0 - Version of Pear Phing package.
#
# Example Usage:
#	sudo ./boostrap.sh
#	sudo ./bootstrap.sh dev true github 3.7.3-1 2.8.0
# 

# Remove leading and trailing whitespace chars.
trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

init() {
	add-apt-repository multiverse
	apt-get update
	mkdir -p build
}

installTools() {
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
}

installPuppet() {
	PUPPET_OK=$(dpkg-query -l puppet | grep puppet)
	if [ "" == "$PUPPET_OK" ] || [ "$FORCE_PUPPET" = "true" ]; then
		echo "Puppet not installed. Installing."
		wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb -P build
		dpkg -i build/puppetlabs-release-trusty.deb
		apt-get update
		apt-get install -yq puppet-common=${PUPPET_VERSION}puppetlabs1 puppet=${PUPPET_VERSION}puppetlabs1 
	else 
		echo -e "Puppet already installed:\n ${PUPPET_OK}"
		puppet --version
	fi 
}

installLibrarian() {
	# Install librarian puppet. Requires bundler package.
	LIBPUP_OK=$(command -v librarian-puppet)
	if [ "" == "$LIBPUP_OK" ]; then
		gem install librarian-puppet -v 1.3.2 --source 'https://rubygems.org'
	else 
		echo -e "librarian-puppet already installed:\n ${LIBPUP_OK}"
		librarian-puppet version
	fi 
	
	curl -O https://raw.githubusercontent.com/mtbvang/devhost/master/Puppetfile
	echo "Install modules with librarian-puppet."
	librarian-puppet update --verbose
}

provision() {
	# Use manifests from github or local files.
	if [ "$SRC_REPO" == "github" ]; then	
	# Clone devhost repository
		if [[ ! -e "modules/devhost" ]]; then
			echo "Cloning repo..."
			git clone https://github.com/mtbvang/puppet-devhost.git modules/devhost
		elif [[ ! -d $dir ]]; then
		    echo "Not cloning devhost repo, devhost folder already exists."
		fi
	else 
		if [ "$SRC_REPO" == "local" ]; then	
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

	puppet apply --summarize --modulepath=modules -e "class { 'devhost': username => ${USER}}"
}

cleanup() {
	# Only clean up if not locally testing.
	if [ "$SRC_REPO" == "github" ]; then
		rm -rf modules
	fi
}

resetPwd() {
	passwd dev
}

# Command line options with default values.
USER==$(trim ${1:-dev})					
FORCE_PUPPET=$(trim ${2:-true})			
SRC_REPO=$(trim ${3:-github})			
PUPPET_VERSION=$(trim ${4:-3.7.3-1})	# string: version of puppet to install.
PHING_VERSION=$(trim ${5:-2.8.0})		# string: version of phing to install.

#echo "SRC_REPO='${SRC_REPO}'"
#echo "FORCE_PUPPET='${FORCE_PUPPET}'"

### Function calls to do work.
init
installTools
installPuppet
installLibrarian
provision
#cleanup
#resetPwd
