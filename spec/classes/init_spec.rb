require 'spec_helper'
describe 'devhost' do

  context 'with defaults for all parameters' do
    it { should contain_class('devhost') }
  end
end
