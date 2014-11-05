#
# Install vagrant and plugins.
#
class devhost::ubuntu::vagrant (
  $downloadUrl              = "https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3_x86_64.deb",
  $user                     = $devhost::params::devuser,
  $userHome                 = "/home/${devhost::params::devuser}",
  $hostPluginVersion        = "2.1.5",
  $vbguestPluginVersion     = "0.10.0",
  $hostsupdatePluginVersion = "0.0.11") {
  ::wget::fetch { "fetchVagrant":
    before      => Package['vagrant'],
    source      => $downloadUrl,
    destination => "/tmp/vagrant.deb",
    # timeout     => 120,
    chmod       => 0755,
  }

  $vagrantRequiredPkgs = ['libxslt-dev', 'libxml2-dev', 'build-essential']

  package { $vagrantRequiredPkgs: ensure => installed }

  package { "vagrant":
    require  => Package[$vagrantRequiredPkgs],
    ensure   => installed,
    provider => dpkg,
    source   => "/tmp/vagrant.deb",
  }

  file { "${userHome}/.vagrant.d":
    require => Package['vagrant'],
    ensure  => 'directory',
    owner   => $user,
    group   => $user,
    # mode    => '0755',
    recurse => true,
  }

  exec { 'vagrant_hosts_plugin':
    environment => "HOME=${userHome}",
    command     => "/usr/bin/vagrant plugin install vagrant-hosts --plugin-version ${hostPluginVersion}",
    require     => [Package['vagrant'], File["${userHome}/.vagrant.d"]],
    logoutput   => on_failure
  }

  exec { 'vagrant_vbguest_plugin':
    environment => "HOME=${userHome}",
    command     => "/usr/bin/vagrant plugin install vagrant-vbguest --plugin-version ${vbguestPluginVersion}",
    require     => [Package['vagrant'], File["${userHome}/.vagrant.d"]],
    logoutput   => on_failure
  }

  exec { 'vagrant_hostsupdater_plugin':
    environment => "HOME=${userHome}",
    command     => "/usr/bin/vagrant plugin install vagrant-hostsupdater --plugin-version ${hostsupdatePluginVersion}",
    require     => [Package['vagrant'], File["${userHome}/.vagrant.d"]],
    logoutput   => on_failure
  }

}