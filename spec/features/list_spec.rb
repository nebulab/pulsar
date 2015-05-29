require 'spec_helper'

RSpec.feature 'List' do
  subject do
    cmd  = RSpec.configuration.pulsar_command
    path = RSpec.configuration.pulsar_conf_path

    `ruby #{cmd} list --conf-repo #{path}`
  end

  context 'is run' do
    scenario 'via a command named list' do
      expect { subject }
        .not_to output(/Could not find command/).to_stderr_from_any_process
    end

    context 'requires a --conf-repo option' do
      subject { `ruby #{RSpec.configuration.pulsar_command} list` }

      scenario 'fails if no option is passed' do
        expect { subject }
          .to output(/No value provided for required options '--conf-repo'/)
          .to_stderr_from_any_process
      end
    end
  end

  context 'when succeeds' do
    context 'lists applications in the pulsar configuration' do
      scenario 'from local folder' do
        is_expected.to match(/blog: production, staging\necommerce: staging/)
      end

      scenario 'from local repository'
      scenario 'from GitHub'
    end
  end
end
