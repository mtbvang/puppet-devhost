class devhost::ubuntu::packages ($installPkgs = $devhost::installPkgs, $uninstallPkgs = $devhost::uninstallPkgs) {
  package { $installPkgs: ensure => 'installed' }

  package { $uninstallPkgs: ensure => 'purged' }

}