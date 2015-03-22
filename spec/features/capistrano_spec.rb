require 'spec_helper'

RSpec.feature 'Capistrano' do
  context 'is run' do
    scenario 'via an executable named pulsar'
    scenario 'with no subcommand'
  end
end
