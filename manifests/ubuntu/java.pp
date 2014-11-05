class devhost::ubuntu::java ($userHome = "/home/${devhost::username}") {
  apt::ppa { 'ppa:webupd8team/java': }

  exec { 'java-license':
    require     => Apt::Ppa['ppa:webupd8team/java'],
    command     => "echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections",
    environment => ["HOME=${userHome}"],
    path        => ['/usr/bin', '/bin', '/sbin'],
    logoutput   => on_failure
  }

  package { "oracle-java7-installer":
    require => Exec['java-license'],
    name    => 'oracle-java7-installer',
    ensure  => 'installed'
  }
}