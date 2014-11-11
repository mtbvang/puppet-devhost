#
# Install vagrant and plugins.
#
class devhost::ubuntu::vagrant (
  $downloadUrl              = $devhost::vagrantDownloadUrl,
  $user                     = $devhost::username,
  $userHome                 = $devhost::userHome,
  $hostPluginVersion        = $devhost::vagrantHostPluginVersion,
  $vbguestPluginVersion     = $devhost::vagrantVbguestPluginVersion,
  $hostsupdatePluginVersion = $devhost::vagrantHostsupdatePluginVersion,
  $cachierPluginVersion     = $devhost::vagrantCachierPluginVersion) {
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

  exec { 'vagrant_cachier_plugin':
    environment => "HOME=${userHome}",
    command     => "/usr/bin/vagrant plugin install vagrant-cachier --plugin-version ${cachierPluginVersion}",
    require     => [Package['vagrant'], File["${userHome}/.vagrant.d"]],
    logoutput   => on_failure
  }

}