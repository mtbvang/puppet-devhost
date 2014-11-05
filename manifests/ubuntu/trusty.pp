#
# Provision a Ubuntu Trusty OS.
#
class devhost::ubuntu::trusty () {
  devhost::users { 'developer': } ->
  class { 'devhost::ubuntu::trusty::install': } ->
  class { 'devhost::ubuntu::trusty::config': }

  contain devhost::ubuntu::trusty::install
  contain devhost::ubuntu::trusty::config
}

class devhost::ubuntu::trusty::install () {
  class { 'devhost::ubuntu::eclipse': }
  contain devhost::ubuntu::eclipse

  class { 'devhost::ubuntu::vagrant': }
  contain devhost::ubuntu::vagrant

  package { 'virtualbox': ensure => 'latest' }

  class { '::devhost::ubuntu::docker': version => '1.2.0', }
  contain 'devhost::ubuntu::docker'

  class { 'devhost::sublimetext2': }
  contain devhost::sublimetext2
}

class devhost::ubuntu::trusty::config () {
  file_line { 'disableGuestAccount':
    line => 'allow-guest=false',
    path => '/usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf'
  }
}

class devhost::ubuntu::trusty::packages () {
  $installPkgs = $devhost::params::installPkgs

  package { $installPkgs: ensure => 'installed' }

  $uninstallPkgs = $devhost::params::uninstallPkgs

  package { $uninstallPkgs: ensure => 'purged' }

  class { 'devhost::ruby': }
  contain devhost::ruby

  devhost::puppet::librarianpuppet { 'librarianPuppet':
    require  => Class['devhost::ruby'],
    userhome => "/home/${devhost::username}"
  }
}
