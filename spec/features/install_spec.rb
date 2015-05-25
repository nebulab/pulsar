require 'spec_helper'

RSpec.feature 'Install' do
  let(:command) { system('ruby ./bin/pulsar install') }

  context 'is run' do
    scenario 'via a command named install' do
      expect { command }
        .not_to output(/Could not find command/).to_stderr_from_any_process
    end
  end

  context 'creates a directory named pulsar-conf' do
    scenario 'with the basic pulsar configuration repository' do
      pending('to be completed...')

      expect { command }
        .to change { File.exist?('./pulsar-conf') }.from(false).to(true)
    end

    scenario 'inside the current directory by default'
    scenario 'to a directory if passed as an argument'
  end
end
