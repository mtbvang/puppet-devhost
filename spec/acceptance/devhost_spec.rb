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

    describe command('vagrant') do
      its(:stdout) { should match(/Vagrant 1.6.3/) }
    end

  end
end
