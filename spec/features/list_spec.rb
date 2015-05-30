require 'spec_helper'

RSpec.feature 'List' do
  subject { `#{cmd} --conf-repo #{repo}` }

  let(:cmd)  { "ruby #{RSpec.configuration.pulsar_command} list" }
  let(:repo) { RSpec.configuration.pulsar_conf_path }

  scenario 'via a subcommand named list' do
    expect { subject }
      .not_to output(/Could not find command/).to_stderr_from_any_process
  end

  context 'requires a --conf-repo option' do
    subject { `#{cmd}` }

    scenario 'fails if no option is passed' do
      expect { subject }
        .to output(/No value provided for required options '--conf-repo'/)
        .to_stderr_from_any_process
    end
  end

  context 'when succeeds' do
    context 'lists applications in the pulsar configuration' do
      scenario 'from a local folder' do
        is_expected.to match(/blog: production, staging\necommerce: staging/)
      end

      scenario 'from a local repository'
      scenario 'from a GitHub repository'
    end
  end

  context 'when fails' do
    context 'because of wrong directory' do
      let(:repo) { './some-wrong-directory' }

      scenario 'says it out loud' do
        is_expected.to match(/Failed to list application and stages./)
      end
    end

    context 'because of empty directory' do
      let(:repo) { RSpec.configuration.pulsar_empty_conf_path }

      scenario 'says it out loud' do
        is_expected.to match(/Failed to list application and stages./)
      end
    end
  end
end
