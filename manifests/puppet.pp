define devhost::puppet::librarianpuppet ($userhome) {
  exec { 'librarianPuppet':
    command   => $devhost::params::librarianPuppetInstallCmd,
    logoutput => on_failure,
    creates   => '/usr/local/bin/puppet',
    unless    => "which librarian-puppet"
  }
}

class devhost::puppet::beaker {
  $beakerPkgs = "make ruby-dev libxml2-dev libxslt1-dev g++"

  package { $beakerPkgs: ensure => 'installed' } ->
  package { 'beaker':
    ensure   => 'installed',
    provider => 'gem',
  }
}

class devhost::puppet ($puppetPackageName = $devhost::params::puppetPackageName, $puppetVersion = $devhost::params::puppetVersion) {
  ::wget::fetch { "fetchPuppet":
    before      => Package['puppetcommon', 'puppet'],
    source      => "https://apt.puppetlabs.com/${puppetPackageName}",
    destination => "/tmp/${puppetPackageName}",
    timeout     => 120,
    chmod       => 0755,
  }

  package { "puppetcommon":
    name     => 'puppet-common',
    ensure   => $puppetVersion,
    provider => apt,
    source   => "/tmp/${puppetPackageName}",
  }

  package { "puppet":
    name     => 'puppet',
    ensure   => $puppetVersion,
    provider => apt,
    source   => "/tmp/${puppetPackageName}",
  }

}