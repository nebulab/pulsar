require 'spec_helper'

RSpec.feature 'Install' do
  let(:command) { system('ruby ./bin/pulsar install') }

  context 'is run' do
    scenario 'via an executable named pulsar-list' do
      expect { command }
        .not_to output(/Could not find command/).to_stderr_from_any_process
    end
  end

  context 'creates a directory' do
    scenario 'with the basic pulsar configuration repository'
    scenario 'inside the current directory by default'
    scenario 'to a directory if passed as an argument'
  end
end
