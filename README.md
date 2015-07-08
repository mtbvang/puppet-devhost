#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with devhost](#setup)
    * [What devhost affects](#what-devhost-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with devhost](#beginning-with-devhost)
4. [Usage - Configuration options and additional functionality](#usage)

## Overview

A puppet module that provisions a Ubuntu 14.04 64bit development host machines with the tools for container and VM based 
development environments. 

The aim is to only have the absolute necessary tools on the host, docker, vagrant, virtualisation tools (vbox, vmwre, kvm et.).
All other project build and develop dependencies are install on a vagrant dev machine to provide environments for multi-project 
work.

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

```sh
sudo curl -O https://raw.githubusercontent.com/mtbvang/devhost/master/bootstrap.sh
sudo chmod +x bootstrap.sh
sudo ./bootstrap.sh
```
Look at the boostrap files for options that can be set through arguments.

## Usage

The devhost class provides some parameters that can be used to configure

## Limitations

Supports only Ubuntu 14.04 64bit. 


