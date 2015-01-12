require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'pry'
require 'beaker/librarian'

hosts.each do |host|
  # Install Puppet
  install_puppet(:version => '3.6.2')
  install_package host, 'git'
  install_package host, 'bundler'
  on host, "gem install librarian-puppet -v 2.0.1 --source 'https://rubygems.org'"
  #install_librarian
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  #c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install dependencies using librarian-puppet
    librarian_install_modules(proj_root, 'devhost')
    # Install module under test
    #puppet_module_install(:source => proj_root, :module_name => 'devhost')
    hosts.each do |host|
      on host, "echo project_root: #{proj_root}"
      on host, 'ls -la /etc/puppet/modules'
      on host, "echo #{host['distmoduledir']}"
      on host, 'puppet config print modulepath'
    end
  end
end
