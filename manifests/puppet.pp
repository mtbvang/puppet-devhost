define devhost::puppet::librarianpuppet ($userhome) {
  exec { 'librarianPuppet':
    require     => Package['bundler'],
    environment => "HOME=${userhome}",
    command     => $devhost::params::librarianPuppetInstallCmd,
    logoutput   => on_failure
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