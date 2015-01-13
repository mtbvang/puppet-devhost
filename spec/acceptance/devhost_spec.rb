require 'spec_helper_acceptance'

describe 'devhost class' do
  
  context 'default parameters' do
    it 'should work with no errors' do
      pp = <<-EOS
        class { 'devhost': }        
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe user('dev') do
      it { should exist }
    end

    describe file('/home/dev') do
      it { should be_directory }
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

    describe command('vagrant -v') do
      its(:stdout) { should match(/Vagrant 1.6.3/) }
    end

    describe package('virtualbox-4.3') do
      it { should be_installed }
    end

    describe command('docker version') do
      its(:stdout) { should match(/Client version: 1.3.1/) }
    end

    describe package('sublime-text') do
      it { should be_installed }
    end

    describe command('bundle version') do
      its(:stdout) { should match(/Bundler version 1.3.5/) }
    end

    describe command('librarian-puppet version') do
      its(:stdout) { should match(/librarian-puppet v2.0.1/) }
    end

    describe package('skype') do
      it { should be_installed }
    end

    describe package('nautilus-dropbox') do
      it { should be_installed }
    end

    describe command('phing --version') do
      its(:stdout) { should match(/Phing 2.8.0/) }
    end

  end
end
