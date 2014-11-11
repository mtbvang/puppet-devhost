require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'pry'

hosts.each do |host|
  # Install Puppet
  install_puppet
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'devhost')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-apt', '--version', '1.6.0'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'leonardothibes-wget', '--version', '1.0.4'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'saz-ssh', '--version', '2.4.0'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'garethr-docker'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'runthebusiness-eclipse', '--version', '1.1.0'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
