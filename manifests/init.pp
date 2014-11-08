# == Class: devhost
#
# Provision a base OS with the tools to do vagrant, docker and vbox based development.
#
# === Parameters
#
# disableGuestAccount
#   Boolean. Set to true to remove the guest login account.
#
# username
#   String. User account that development work will be done under. A username must be specified.
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
# installPkgs
#   Array. Packages to install.
#
# uninstallPkgs
#   Array. Packages to uninstall.
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
class devhost (
  $disableGuestAccount   = true,
  $username              = $devhost::params::devUser,
  $userHome              = $devhost::params::devUserHome,
  $userGroups            = $devhost::params::devUserGroups,
  $userPassword          = $devhost::params::devUserPassword,
  $installPkgs           = $devhost::params::installPkgs,
  $uninstallPkgs         = $devhost::params::uninstallPkgs,
  $dockerVersion         = '1.2.0',
  $dockerServiceProvider = 'upstart',
  $vagrantDownloadUrl    = "https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3_x86_64.deb") inherits params {
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

