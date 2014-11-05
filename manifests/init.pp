# == Class: devhost
#
# Provision a base OS with the tools to do vagrant, docker and vbox based development.
#
# === Parameters
#
# Document parameters here.
#
# [username]
#   User account that development work will be done under.
#
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
class devhost ($username = 'dev') inherits params {
  Exec {
    path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/", "/usr/local/bin"] }

  $updatePkgManager = $devhost::params::updatePkgManager

  exec { "updatePackageManager":
    command => $updatePkgManager,
    timeout => 600
  }

  case $::osfamily {
    'Debian' : {
      #class { 'apt': }

      case $::lsbdistcodename {
        'trusty' : {
          class { 'devhost::ubuntu::trusty': require => [Exec["updatePackageManager"], ] }
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

