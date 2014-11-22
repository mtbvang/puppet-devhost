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
# dockerVersion
#   String. Version of docker to install.
#
# dockerServiceProvier
#   String. One of the values from the provider attribute of the service resource type.
#
# vagrantDownloadurl
#   String. URL of vagrant deb package.
#
# vagrantHostPluginVersion
#   String. Version of vagrant-hosts plugin.
#
# vagrantVbguestPluginVersion
#   String. Version of vagrant vagrant-vbguest plugin.
#
# vagrantHostsupdatePluginVersion
#   String. Version of vagrant vagrant-hostupdater plugin.
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
  $desktopPkgs           = $devhost::params::desktopPkgs,
  $uninstallPkgs         = $devhost::params::uninstallPkgs,
  $dockerVersion         = '1.3.1',
  $dockerServiceProvider = 'upstart',
  $vagrantDownloadUrl    = "https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3_x86_64.deb",
  $vagrantHostPluginVersion        = "2.1.5",
  $vagrantVbguestPluginVersion     = "0.10.0",
  $vagrantHostsupdatePluginVersion = "0.0.11",
  $vagrantCachierPluginVersion     = "1.1.0") inherits params {
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
          class { 'devhost::ubuntu::trusty': require => Exec["updatePackageManager"] }
          contain devhost::ubuntu::trusty
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

