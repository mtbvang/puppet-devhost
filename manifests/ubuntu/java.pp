class devhost::ubuntu::java ($userhome = "/home/${devhost::username}", $ppa = 'ppa:webupd8team/java') {
  apt::ppa { $ppa: } ->
  exec { 'java-license':
    command     => "echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections",
    environment => ["HOME=${userhome}"],
    path        => ['/usr/bin', '/bin', '/sbin'],
    logoutput   => on_failure
  } ->
  package { "oracle-java7-installer":
    name   => 'oracle-java7-installer',
    ensure => 'installed'
  }
}