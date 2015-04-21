#
# Provision a Ubuntu Trusty OS.
#
class devhost::ubuntu::trusty () {
  class { 'devhost::ubuntu::trusty::install': } ->
  class { 'devhost::ubuntu::trusty::config': }

  contain devhost::ubuntu::trusty::install
  contain devhost::ubuntu::trusty::config
}

class devhost::ubuntu::trusty::install () {
  class { '::apt': always_apt_update => true, }
  contain apt

  class { 'devhost::ubuntu::java': }
  contain devhost::ubuntu::java

  class { 'devhost::ubuntu::eclipse': require => Class['devhost::ubuntu::java'] }
  contain devhost::ubuntu::eclipse

  if $devhost::installVagrant == true {
    class { 'mtbvang::ubuntu::vagrant':
      user     => $devhost::username,
      userHome => $devhost::userhome
    }
    contain mtbvang::ubuntu::vagrant
  }

  class { 'mtbvang::ubuntu::virtualbox':
  }
  contain mtbvang::ubuntu::virtualbox

  class { '::mtbvang::ubuntu::docker':
    version          => $devhost::dockerVersion,
    docker_sudo_user => $devhost::username
  }
  contain mtbvang::ubuntu::docker

  class { 'devhost::sublimetext': }
  contain devhost::sublimetext

  class { 'devhost::ubuntu::packages': }
  contain devhost::ubuntu::packages

  class { 'devhost::ruby': }
  contain devhost::ruby

  class { 'mtbvang::puppet::librarianpuppet': require => Class['devhost::ruby'], }

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
    exec { 'ensureLightDMDirExists':
      command   => "mkdir -p /usr/share/lightdm/lightdm.conf.d",
      path      => ['/usr/bin', '/bin', '/sbin'],
      logoutput => on_failure
    } ->
    file { 'disableGuestAccount':
      ensure  => present,
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

  file { "${userhome}/.bashrc":
    source => 'puppet:///modules/devhost/ubuntu/bashrc',
    owner  => $username,
    group  => $username,
    mode   => 644,
  }

  file { "${userhome}/.bash_aliases":
    source => 'puppet:///modules/devhost/ubuntu/bash_aliases',
    owner  => $username,
    group  => $username,
    mode   => 644,
  }

  exec { 'setDefaultTerminal':
    command   => "gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/gnome-terminal",
    path      => ['/usr/bin', '/bin', '/sbin'],
    logoutput => on_failure
  }

}
