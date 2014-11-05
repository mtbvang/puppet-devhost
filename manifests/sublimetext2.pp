class devhost::sublimetext2 ($ppa = 'ppa:webupd8team/sublime-text-2') {
  apt::ppa { $ppa: }

  package { "sublime-text":
    require => Apt::Ppa[$ppa],
    ensure  => 'installed'
  }
}