require 'spec_helper'
describe 'aquamar' do
  context 'with default values for all parameters' do
    it { should contain_class('aquamar') }
  end
end
