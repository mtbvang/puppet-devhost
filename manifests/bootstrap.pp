class devhost::bootstrap () inherits devhost::params {
  package { "aptBootstrapPackages":
    name   => $devhost::params::bootstrapPkgs,
    ensure => 'installed'
  }

}