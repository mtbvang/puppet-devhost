#
# Parameters:
#   password default=password123. Generated with mkpasswd -m sha-512 -s
#
define devhost::users (
  $username = $devhost::params::devUser,
  $home     = $devhost::params::devUserHome,
  $groups   = $devhost::params::devUserGroups,
  $password = $devhost::params::devUserPassword) {
  if $username == undef {
    notice("No developer user created as username not specified. ")
  } else {
    $rubyShadowPkg = $devhost::params::rubyShadowPkg

    package { $rubyShadowPkg: ensure => installed, }

    if member($groups, 'sudo') {
      file { "/etc/sudoers.d/${username}":
        content => "%${username} ALL=NOPASSWD:ALL",
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
      }
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

}
