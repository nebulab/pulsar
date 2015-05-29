require 'spec_helper'

RSpec.feature 'List' do
  subject { `ruby #{RSpec.configuration.pulsar_command} list` }

  scenario 'is run via a command named list' do
    expect { subject }
      .not_to output(/Could not find command/).to_stderr_from_any_process
  end

  context 'when succeeds' do
    context 'lists applications in the pulsar configuration' do
      scenario 'from local folder'
      scenario 'from local repository'
      scenario 'from GitHub'
    end
  end
end
