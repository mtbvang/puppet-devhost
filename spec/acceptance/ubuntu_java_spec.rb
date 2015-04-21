require 'spec_helper_acceptance'

describe 'devhost::ubuntu::java class' do

  context 'default parameters' do
    it 'should work with no errors' do
      pp = <<-EOS
        class { 'devhost::ubuntu::java': }
        contain devhost::ubuntu::java    
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe command('java -version | grep version') do
      its(:stdout) { should match(/java version "1.7.0_80"/) }
    end

  end
end
