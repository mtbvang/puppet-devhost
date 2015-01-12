#
# Provision a Ubuntu Trusty OS.
#
class devhost::ubuntu::trusty () {
  devhost::users { 'defaultuser':
    username => $devhost::username,
    home     => $devhost::userhome,
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

  if $devhost::installVagrant == true {
    class { 'mtbvang::ubuntu::vagrant': }
    contain mtbvang::ubuntu::vagrant
  }

  class { 'mtbvang::ubuntu::virtualbox':
  }
  contain mtbvang::ubuntu::virtualbox

  class { '::mtbvang::ubuntu::docker': version => $devhost::dockerVersion, }
  contain 'mtbvang::ubuntu::docker'

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

  if $devhost::installSkype == true {
    class { 'mtbvang::ubuntu::skype': }
    contain mtbvang::ubuntu::skype
  }

  if $devhost::installDropbox == true {
    package { $devhost::params::dropboxPkg: ensure => 'installed' }
  }

  if $devhost::installPhing == true {
    php::pear::module { 'phing':
      repository  => 'pear.phing.info',
      version     => '2.8.0',
      use_package => 'no',
    }
  }

}

class devhost::ubuntu::trusty::config ($username = $devhost::username, $userhome = $devhost::userhome) {
  if $devhost::disableGuestAccount == true {
    file { 'disableGuestAccount':
      path    => '/usr/share/lightdm/lightdm.conf.d/50-no-guest.conf',
      content => '[SeatDefaults]\nallow-guest=false\n',
    }
  } else {
    warning('Your guest account was not disabled during provisioning.')
  }

  $openboxConfigDir = ["${userhome}/.config", "${userhome}/.config/openbox"]

  file { $openboxConfigDir:
    ensure => "directory",
    owner  => $username,
    group  => $username,
    mode   => 700
  }

  file { "${userhome}/.config/openbox/lubuntu-rc.xml":
    require => File[$openboxConfigDir],
    source  => 'puppet:///modules/devhost/ubuntu/lubuntu-rc.xml',
    owner   => $username,
    group   => $username,
    mode    => 644,
  }

  file { "${userhome}/.config/openbox/lxde-rc.xml":
    require => File[$openboxConfigDir],
    source  => 'puppet:///modules/devhost/ubuntu/lxde-rc.xml',
    owner   => $username,
    group   => $username,
    mode    => 644,
  }

  file { "${userhome}/.config/openbox/rc.xml":
    require => File[$openboxConfigDir],
    source  => 'puppet:///modules/devhost/ubuntu/rc.xml',
    owner   => $username,
    group   => $username,
    mode    => 644,
  }
}
