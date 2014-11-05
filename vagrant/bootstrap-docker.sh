#!/bin/bash

PUPPET_VERSION=$1

export DEBIAN_FRONTEND=noninteractive

# Only if symlink hasn't been created to avoid error.
if [ ! -L  "/sbin/initctl" ]; then
	# Work around for upstart docker issues. https://github.com/docker/docker/issues/1024 that
	# causes error: "initctl: Unable to connect to Upstart: Failed to connect to socket /com/ubuntu/upstart: Connection refused"
	echo "/sbin/initctl not found! Linking to it /bin/true"
	dpkg-divert --local --rename --add /sbin/initctl
	ln -s /bin/true /sbin/initctl
fi

ls -la /vagrant/vagrant
source /vagrant/vagrant/bootstrap.sh $PUPPET_VERSION

export DEBIAN_FRONTEND=newt
