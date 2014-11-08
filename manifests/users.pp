#
# Parameters:
#   password default=password123. Generated with mkpasswd -m sha-512 -s
#
define devhost::users (
  $username = $devhost::params::devUser,
  $home     = $devhost::params::devUserHome,
  $groups   = $devhost::params::devUserGroups,
  $password = $devhost::params::devUserPassword) {
  $rubyShadowPkg = $devhost::params::rubyShadowPkg

  package { $rubyShadowPkg: ensure => installed, }

  if $username == undef {
    fail("A username must be defined.")
  }

  user { $username:
    require    => Package[$rubyShadowPkg],
    groups     => $groups,
    ensure     => present,
    home       => $home,
    managehome => yes,
    password   => $password,
  }

}
