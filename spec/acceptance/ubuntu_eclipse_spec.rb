require 'spec_helper_acceptance'

describe 'devhost::ubuntu::eclipse class' do

  context 'default parameters' do
    it 'should work with no errors' do
      pp = <<-EOS
        class { 'devhost::ubuntu::java': }
        contain devhost::ubuntu::java
        
        class { 'devhost::ubuntu::eclipse': require => Class['devhost::ubuntu::java'] }
        contain devhost::ubuntu::eclipse      
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe file('/usr/bin/eclipse') do
      it { should be_symlink }
    end

    describe file('/usr/lib/eclipse') do
      it { should be_directory }
    end

    describe command('cat /usr/lib/eclipse/.eclipseproduct | grep version') do
      its(:stdout) { should match(/version=4.3.2/) }
    end

  end
end
