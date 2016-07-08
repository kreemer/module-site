require 'spec_helper'
describe 'site' do

  context 'with defaults for all parameters' do
    it { should contain_class('site') }
  end
end
