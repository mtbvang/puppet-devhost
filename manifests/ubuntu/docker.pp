class devhost::ubuntu::docker (
  $version          = '1.2.0',
  $service_provider = 'init',
  $docker_sudo_user = $devhost::params::devUser,
  $service_enable   = true,
  $service_state    = 'running',
  $service_binary   = undef,
  $service_start    = undef,
  $service_stop     = undef,
  $service_restart  = undef,
  $service_status   = undef,) {
  class { '::docker':
    version          => $version,
    service_provider => $service_provider,
    service_enable   => $service_enable,
    service_state    => $service_state,
    service_binary   => $service_binary,
    service_start    => $service_start,
    service_stop     => $service_stop,
    service_status   => $service_status,
    service_restart  => $service_restart,
  }
  contain 'docker'

  # Allows docker to run as sudo.
  exec { 'dockersudo':
    require     => Class['::docker'],
    notify      => Exec['dockerRestart'],
    environment => "HOME=/home/${docker_sudo_user}",
    command     => "sudo gpasswd -a ${docker_sudo_user} docker",
    logoutput   => on_failure
  }

  exec { 'dockerRestart':
    user      => root,
    command   => "service docker stop; sleep 1; service docker start",
    onlyif    => "service docker status",
    logoutput => on_failure
  }

  # configure docker and virtualbox iptable rules to allow their networks to reach each other.
  exec { 'dockerToVboxnet1':
    environment => "HOME=/home/${docker_sudo_user}",
    command     => 'iptables -A FORWARD -i docker0 -o vboxnet1 -s 172.17.0.0/16 -d 10.0.0.0/8 -j ACCEPT',
    logoutput   => on_failure
  }

  exec { 'vboxnet1ToDocker':
    environment => "HOME=/home/${docker_sudo_user}",
    command     => 'iptables -A FORWARD -o docker0 -i vboxnet1 -d 172.17.0.0/16 -s 10.0.0.0/8 -j ACCEPT',
    logoutput   => on_failure
  }
}