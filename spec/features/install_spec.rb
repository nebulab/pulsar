require 'spec_helper'

RSpec.feature 'Install' do
  context 'is run' do
    scenario 'via an executable named pulsar-utils'
    scenario 'with the install subcommand'
  end

  context 'creates a directory' do
    scenario 'with the basic pulsar configuration repository'
    scenario 'inside the current directory by default'
    scenario 'to a directory if passed as an argument'
  end
end
