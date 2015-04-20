class devhost::sublimetext2 ($ppa = 'ppa:webupd8team/sublime-text-2') {
  exec { 'addPPASublime':
    command   => "add-apt-repository ${ppa}; apt-get update",
    path      => ['/usr/bin', '/bin', '/sbin'],
    logoutput => on_failure
  } ->
  package { "sublime-text":
    require => Apt::Ppa[$ppa],
    ensure  => 'installed'
  }
}