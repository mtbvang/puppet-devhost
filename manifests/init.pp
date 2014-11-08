# == Class: devhost
#
# Provision a base OS with the tools to do vagrant, docker and vbox based development.
#
# === Parameters
#
# Document parameters here.
#
# username
#   String. User account that development work will be done under. Setting to 'undef' will not create a default user.
#
# userHome
#   String. Home directory for user. Only takes effect if username is set and user is created.
#
# userGroups
#   Array. The groups that the user belongs to. Only takes effect if username is set and user is created.
#
# userPassword
#   sha-512. The password of the user. Only takes effect if username is set and user is created. Generate with 'mkpasswd -m sha-512
#   -s'
#
# disableGuestAccount
#   Boolean. Set to true to remove the guest login account.
#
# === Variables
#
#  No variables
#
# === Examples
#
#  class { devhost: }
#
# === Authors
#
# Vang Nguyen <mtb.vang@gmail.com>
#
class devhost ($username = undef, $userHome = undef, $userGroups = undef, $userPassword = undef, $disableGuestAccount = true) 
inherits params {
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/", "/usr/local/bin"] }

  $updatePkgManager = $devhost::params::updatePkgManager

  exec { "updatePackageManager":
    command => $updatePkgManager,
    timeout => 600
  }

  case $::osfamily {
    'Debian' : {
      case $::lsbdistcodename {
        'trusty' : {
          class { 'devhost::ubuntu::trusty': require => [Exec["updatePackageManager"],] }
        }
        default  : {
          fail("Unsupported Debian distribution: ${::lsbdistcodename}")
        }
      }
    }
    default  : {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  }

}

