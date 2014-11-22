class devhost::ubuntu::packages (
  $installPkgs   = $devhost::installPkgs,
  $uninstallPkgs = $devhost::uninstallPkgs,
  $desktopPkgs   = $devhost::desktopPkgs,) {
  package { $installPkgs: ensure => 'installed' }

  package { $uninstallPkgs: ensure => 'purged' }

  if !empty($desktopPkgs) {
    package { $desktopPkgs: ensure => 'installed' }
  }
}