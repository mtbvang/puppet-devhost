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

  config.vm.synced_folder "/home/dev/code", "/vagrant_data"

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # A docker for doing development work on this module.
  config.vm.define "dev" do |dev|
    dev.vm.hostname = "docker.dev.local"

    # Boostrap docker image with shell provisioner.
    dev.vm.provision "shell" do |s|
      s.path = "vagrant/bootstrap-docker.sh"
      s.args = "3.6.2-1"
    end

    # Provision
    dev.vm.provision "shell" do |s|
      s.path = "vagrant/provisioning/dev.sh"
    end

    dev.vm.provider "docker" do |d|
      d.cmd     = DOCKER_CMD
      d.image   = "#{DOCKER_IMAGE_REPO}/#{DOCKER_IMAGE_NAME}:#{DOCKER_IMAGE_TAG}"
      d.has_ssh = true
      d.privileged = true
      d.name = "devhost.dev.local"
    end
  end

  # A Ubuntu Trusty machine for testing this module.
  config.vm.define "testing",  primary: true do |t|
    # Create symlinks to access graph files
    t.vm.provision "shell", inline: "mkdir -p /var/lib/puppet/state/graphs && ln -sf /vagrant /var/lib/puppet/state/graphs"

    t.vm.box = "trusty-desktop-amd64.box"

    t.vm.hostname = "vbox.dev.local"
    t.vbguest.auto_update = true

    t.vm.provision "shell" do |s|
      s.path = "vagrant/bootstrap.sh"
      s.args = "3.6.2-1"
    end

    # /usr/share/zoneinfo/Europe/Copenhagen
    if ENV.key? "VAGRANT_LOCAL_TIME"
      t.vm.provision "shell",
      inline: "cp #{ENV['VAGRANT_LOCAL_TIME']} /etc/localtime"
    end

    t.vm.provider "virtualbox" do |vb|
      # Headless mode boot
      vb.gui = true
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "1536", "--vram", "128" ]
      vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all" ]
    end

    # Enable provisioning with Puppet stand alone.  Puppet manifests
    # are contained in a directory path relative to this Vagrantfile.
    t.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "default.pp"
      puppet.module_path = ["build/modules"]
      puppet.options = "--summarize --graph --graphdir '/vagrant/build'"
    end
  end

end
