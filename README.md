#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with devhost](#setup)
    * [What devhost affects](#what-devhost-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with devhost](#beginning-with-devhost)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

A puppet module for provisioning development host machines with the tools for container and VM based development environments. 
The aim is to only have the absolute necessary tools on the host, docker, vagrant, virtualisation tools (vbox, vmwre, kvm et.).
All other project build and develop dependencies are install on a vagrant dev machine to allow true multi-project work.

## Module Description

Installs the following tools on the host:
- dev user and home
- docker
- eclipse kepler
- java 7
- vagrant
- puppet
- ruby
- sublimetext2
- virtualbox
- the following packages by default:
    - chromium-browser
    - cmake
    - colordiff
    - curl
    - emacs
    - g++
    - git
    - htop
    - iotop
    - jedit
    - libtool
    - libxml2-dev
    - libxslt1-dev
    - lubuntu-desktop
    - meld
    - mysql-workbench
    - password-gorilla
    - ruby-dev
    - screen
    - skype
    - sshfs
    - subversion
    - sysstat
    - whois
    - xchat

## Setup

### What devhost affects

The module description list what's installed.

### Setup Requirements **OPTIONAL**

Requires Ubuntu 14.04 64bit for docker. Requires curl to download the boostrap script to kick things off. This has only 

### Beginning with devhost

On a clean Ubuntu 14.04 64bit OS in  a working or tmp folder run the following to download and the bootstrap script to 
kick things off:

- sudo curl -O https://raw.githubusercontent.com/mtbvang/devhost/master/bootstrap.sh
- sudo chmod +x bootstrap.sh
- sudo ./bootstrap.sh

Look at the boostrap files for options that can be set through arguments.

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Supports only Ubuntu 14.04 64bit. 

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.
