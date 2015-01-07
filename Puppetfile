#!/usr/bin/env ruby
#^syntax detection

forge "http://forge.puppetlabs.com"

mod 'puppetlabs/apt', '1.6.0'
#mod 'runthebusiness/eclipse', '1.1.0'
mod 'leonardothibes/wget', '1.0.4'
mod 'saz/ssh', '2.4.0'
mod 'opentable/puppetversion', '1.0.0'
mod 'ploperations/bundler', '1.0.1'

# Updates to support upstart in docker. Tests need to be written before the pull request will be accepted. https://github.com/garethr/garethr-docker/pull/95
mod 'garethr/docker',
  :git => 'git://github.com/mtbvang/garethr-docker.git'

# Version 1.1.0 has a bug. This pull request fixes it so the next verison should have include it. https://github.com/runthebusiness/puppet-eclipse/pull/8
mod 'runthebusiness/eclipse',
  :git => 'https://github.com/runthebusiness/puppet-eclipse.git'
  
mod 'mtbvang/mtbvang',
  :git => 'git://github.com/mtbvang/puppet-mtbvang.git'
#  :ref => '>= 0.1.0'
  
mod 'mtbvang/devpuppet',
  :git => 'git://github.com/mtbvang/puppet-devpuppet.git'
#  :ref => '>= 0.1.0'
  