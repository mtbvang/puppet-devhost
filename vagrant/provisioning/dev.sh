#!/bin/bash

# Installs the tools on a Ubuntu 14.04 OS to allow development and testing of module.

add-apt-repository multiverse
apt-get update

### Install required tools
apt-get install -yq wget git bundler ruby-dev libxml2-dev libxslt1-dev g++ build-essential

bundle install --gemfile /vagrant/Gemfile

wget -P /usr/tmp https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3_x86_64.deb
dpkg -i /usr/tmp/vagrant_1.6.3_x86_64.deb

vagrant plugin install vagrant-hosts --plugin-version 2.1.5
vagrant plugin install vagrant-vbguest --plugin-version 0.10.0
vagrant plugin install vagrant-hostsupdater --plugin-version 0.0.11
vagrant plugin install vagrant-cachier --plugin-version 1.1.0


