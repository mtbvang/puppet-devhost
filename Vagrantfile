# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  DOCKER_IMAGE_REPO = "mtbvang"
  DOCKER_IMAGE_NAME = "ubuntu-vagrant"
  DOCKER_IMAGE_TAG = "14.04"

  DOCKER_SYNC_FOLDER_HOST = "/home/dev/code"
  DOCKER_SYNC_FOLDERL_GUEST = "/vagrant_data"
  DOCKER_CMD = ["/usr/sbin/sshd", "-D", "-e"]

  # Create symlinks to access graph files
  config.vm.provision "shell", inline: "mkdir -p /var/lib/puppet/state/graphs && ln -sf /vagrant /var/lib/puppet/state/graphs"

  # A docker machine for module testing.
  config.vm.define "dev-docker" do |conf|
    conf.vm.hostname = "docker.dev.local"

    # Boostrap docker image with shell provisioner.
    conf.vm.provision "shell" do |s|
      s.path = "vagrant/bootstrap-docker.sh"
      s.args = "3.6.2-1"
    end

    conf.vm.provider "docker" do |d|
      d.cmd     = DOCKER_CMD
      d.image   = "#{DOCKER_IMAGE_REPO}/#{DOCKER_IMAGE_NAME}:#{DOCKER_IMAGE_TAG}"
      d.has_ssh = true
      d.privileged = true
      d.name = "devhost.dev.local"
    end
  end

  # A Ubuntu Trusty machine for module testing.
  config.vm.define "dev",  primary: true do |conf|
    conf.vm.box = "trusty-desktop-amd64.box"

    conf.vm.hostname = "vbox.dev.local"
    conf.vbguest.auto_update = true

    conf.vm.provision "shell" do |s|
      s.path = "vagrant/bootstrap.sh"
      s.args = "3.6.2-1"
    end

    # /usr/share/zoneinfo/Europe/Copenhagen
    if ENV.key? "VAGRANT_LOCAL_TIME"
      conf.vm.provision "shell",
      inline: "cp #{ENV['VAGRANT_LOCAL_TIME']} /etc/localtime"
    end

    conf.vm.provider "virtualbox" do |vb|
      # Headless mode boot
      vb.gui = true
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "1536", "--vram", "128" ]
      vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all" ]
    end

    # Enable provisioning with Puppet stand alone.  Puppet manifests
    # are contained in a directory path relative to this Vagrantfile.
    conf.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "default.pp"
      puppet.module_path = "build/modules"
      puppet.options = "--verbose"
    end
  end

  config.vm.synced_folder "/home/dev/code", "/vagrant_data"

end
