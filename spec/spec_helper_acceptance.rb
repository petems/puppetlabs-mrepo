require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'mrepo')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib -v 4.12.0'), { :acceptable_exit_codes => [0] }
      on host, puppet('module', 'install', 'puppetlabs-apache -v 0.6.0'), { :acceptable_exit_codes => [0] }
      on host, puppet('module', 'install', 'puppetlabs-vcsrepo -v 0.0.3'), { :acceptable_exit_codes => [0] }
      on host, puppet('module', 'install', 'puppet-staging -v 2.0.0'), { :acceptable_exit_codes => [0] }
    end
  end
end
