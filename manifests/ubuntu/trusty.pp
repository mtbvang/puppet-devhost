#
# Provision a Ubuntu Trusty OS.
#
class devhost::ubuntu::trusty () {
  devhost::users { 'defaultuser':
    username => $devhost::username,
    home     => $devhost::userHome,
    groups   => $devhost::userGroups,
    password => $devhost::userPassword,
  } ->
  class { 'devhost::ubuntu::trusty::install': } ->
  class { 'devhost::ubuntu::trusty::config': }

  contain devhost::ubuntu::trusty::install
  contain devhost::ubuntu::trusty::config
}

class devhost::ubuntu::trusty::install () {
  class { 'devhost::ubuntu::eclipse': }
  contain devhost::ubuntu::eclipse

  class { 'common::ubuntu::vagrant': }
  contain common::ubuntu::vagrant

  class { 'common::ubuntu::virtualbox': }
  contain common::ubuntu::virtualbox

  class { '::devhost::ubuntu::docker': version => $devhost::dockerVersion, }
  contain 'devhost::ubuntu::docker'

  class { 'devhost::sublimetext2': }
  contain devhost::sublimetext2

  class { 'devhost::ubuntu::packages': }
  contain devhost::ubuntu::packages

  class { 'devhost::ruby': }
  contain devhost::ruby

  devhost::puppet::librarianpuppet { 'librarianPuppet':
    require  => Class['devhost::ruby'],
    userhome => "/home/${devhost::username}"
  }

  class { 'common::ubuntu::skype':
  }
  contain common::ubuntu::skype
}

class devhost::ubuntu::trusty::config () {
  if $devhost::disableGuestAccount == true {
    file { 'disableGuestAccount':
      path    => '/usr/share/lightdm/lightdm.conf.d/50-no-guest.conf',
      content => '[SeatDefaults]\nallow-guest=false\n',
    }
  } else {
    warning('Your guest account was not disabled during provisioning.')
  }
}
