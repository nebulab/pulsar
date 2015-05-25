require 'spec_helper'

RSpec.describe Pulsar::Install do
  subject(:context) { Pulsar::Install.call(directory: '.') }

  describe '.call' do
    it 'copies a template directory to destination'
  end
end
