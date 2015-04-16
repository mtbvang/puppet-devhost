# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
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
