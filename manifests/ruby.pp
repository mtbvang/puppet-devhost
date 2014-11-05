class devhost::ruby {
  package { 'bundler': ensure => $devhost::params::bundlerVersion }
}