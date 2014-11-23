# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "trusty-desktop-amd64.box"

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # A docker for doing development work on this module.
  config.vm.define "nested" do |d|
    d.vm.box = "puppetlabs/ubuntu-14.04-32-nocm"
    d.vm.box_url = "https://vagrantcloud.com/puppetlabs/ubuntu-14.04-32-nocm"
    d.vbguest.auto_update = false

    d.vm.hostname = "nested.dev.local"

    d.vm.provider "virtualbox" do |vb|
      # Headless mode boot
      vb.gui = false
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "512", "--vram", "128" ]
      vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all" ]
    end
  end

  # A docker for doing development work on this module.
  config.vm.define "dev" do |d|
    d.vm.hostname = "devhost.dev.local"

    d.vbguest.auto_update = false
    d.vbguest.iso_path = 'http://download.virtualbox.org/virtualbox/4.3.18/VBoxGuestAdditions_4.3.18.iso'

    # Boostrap docker image with shell provisioner.
    d.vm.provision "shell" do |s|
      s.path = "vagrant/bootstrap.sh"
      s.args = "3.6.2-1"
    end

    # Provision
    #    d.vm.provision "shell" do |s|
    #      s.path = "vagrant/provisioning/dev.sh"
    #    end

    # Enable provisioning with Puppet stand alone.  Puppet manifests
    # are contained in a directory path relative to this Vagrantfile.
    d.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "modules/devpuppet/manifests"
      puppet.manifest_file  = "default.pp"
      puppet.module_path = ['./modules', './']
      puppet.options = "--summarize --graph --graphdir '/vagrant/build'"
    end

    d.vm.provider "virtualbox" do |vb|
      # Headless mode boot
      vb.gui = true
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "4096", "--vram", "128" ]
      vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all" ]
    end
  end

  # A Ubuntu Trusty machine for testing this module.
  config.vm.define "testing",  primary: true do |t|

    t.vm.hostname = "vbox.dev.local"
    t.vbguest.auto_update = false
    t.vbguest.iso_path = 'http://download.virtualbox.org/virtualbox/4.3.18/VBoxGuestAdditions_4.3.18.iso'

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
      puppet.module_path = ['modules']
      puppet.options = "--summarize --graph --graphdir '/vagrant/build'"
    end
  end

end
