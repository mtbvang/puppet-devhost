# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "trusty-desktop-amd64.box"

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # Virtual development environment containing all the tools necessary to do development work on devhost.
  # Note: Can't run acceptance tests as vbox doesn't support nested 64bit and there is no 32bit docker package.
  # 64bit nesting works with VMWare provider.
  config.vm.define "dev-vbox" do |d|
    d.vm.hostname = "devhost.dev.local"
    d.vm.box = "ubuntu-14.04-amd64-vbox-desktop"
    d.vm.box_url = "https://drive.google.com/file/d/0B8pj-t-rM-7BYU1NY3NkeUlLZFU/view?usp=sharing"

    d.vbguest.auto_update = false
    d.vbguest.iso_path = 'http://download.virtualbox.org/virtualbox/4.3.18/VBoxGuestAdditions_4.3.18.iso'

    # Preprovisioning bootstrap
    d.vm.provision "shell" do |s|
      s.path = "vagrant/bootstrap.sh"
      s.args = "3.7.3-1 true"
    end

    # Provisioning
    d.vm.provision "shell", inline: "cd /vagrant; puppet apply --summarize --modulepath=modules --graph --graphdir '/vagrant/build' -e \"class { 'devpuppet': }\""

    d.vm.provider "virtualbox" do |vb|
      # Headless mode boot
      vb.gui = true
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "4096", "--vram", "128" ]
      vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all" ]
    end
  end

  config.vm.define "dev-vmware" do |d|
    d.vm.hostname = "devhost.dev.local"
    d.vm.box = "ubuntu-14.04-amd64-vbox-desktop"
    d.vm.box_url = "https://drive.google.com/file/d/0B8pj-t-rM-7BYU1NY3NkeUlLZFU/view?usp=sharing"

    d.vbguest.auto_update = false
    d.vbguest.iso_path = 'http://download.virtualbox.org/virtualbox/4.3.18/VBoxGuestAdditions_4.3.18.iso'

    # Preprovisioning bootstrap
    d.vm.provision "shell" do |s|
      s.path = "vagrant/bootstrap.sh"
      s.args = "3.7.3-1 true"
    end

    # Provisioning
    d.vm.provision "shell", inline: "cd /vagrant; puppet apply --summarize --modulepath=modules --graph --graphdir '/vagrant/build' -e \"class { 'devpuppet': }\""

    d.vm.provider "vmware" do |vw|

    end
  end

  # A Ubuntu Trusty machine for smoke testing this module.
  config.vm.define "smoketest",  primary: true do |st|

    st.vm.box = "puppetlabs/ubuntu-14.04-64-nocm"
    st.vm.box_url = "https://vagrantcloud.com/puppetlabs/ubuntu-14.04-64-nocm"

    st.vm.hostname = "devhost.dev.local"
    st.vbguest.auto_update = false
    st.vbguest.iso_path = 'http://download.virtualbox.org/virtualbox/4.3.18/VBoxGuestAdditions_4.3.18.iso'

    # Preprovisioning boot strapping
    st.vm.provision "shell" do |s|
      s.path = "vagrant/bootstrap.sh"
      s.args = "3.6.2-1"
    end

    # Provision with shell provisioner
    # st.vm.provision "shell", inline: "cd /vagrant; puppet apply --summarize --modulepath=modules --graph --graphdir '/vagrant/build' -e \"class { 'devhost': }\""

    # Provision with puppet provisioner
    st.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "default.pp"
      puppet.module_path = ["modules"]
      puppet.options = "--summarize --graph --graphdir '/vagrant/build'"
    end

    # Optionally set lcoal timezone e.g. set command line env varialbe VAGRANT_LOCAL_TIME=/usr/share/zoneinfo/Europe/Copenhagen
    if ENV.key? "VAGRANT_LOCAL_TIME"
      st.vm.provision "shell",
      inline: "cp #{ENV['VAGRANT_LOCAL_TIME']} /etc/localtime"
    end

    st.vm.provider "virtualbox" do |vb|
      # Set to true to see desktop or console window.
      vb.gui = true
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "1536", "--vram", "128" ]
      vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all" ]
    end
  end

end
