require 'spec_helper'

RSpec.feature 'List' do
  context 'is run' do
    scenario 'via an executable named pulsar-utils'
    scenario 'with the list subcommand'
  end

  context 'lists applications in the pulsar configuration' do
    scenario 'from local folder'
    scenario 'from local repository'
    scenario 'from GitHub'
  end
end
