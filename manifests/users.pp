#
# Parameters:
#   password default=password123. Generated with mkpasswd -m sha-512 -s
#
define devhost::users (
  $username = 'dev',
  $home     = '/home/dev',
  $groups   = ['sudo'],
  $password = '$6$Ne11NDd00.gyr$wCVgF/PrwbunihnHyJXBkE5kklPh3EAeY3.qmqO3hz6pExONA6p.472BpQt6eh2zn6qIRBO26LlUgGsGE36s51',) {
  $rubyShadowPkg = $devhost::params::rubyShadowPkg

  package { $rubyShadowPkg: ensure => installed, }

  if $username == undef {
    fail("A username must be defined.")
  }

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
