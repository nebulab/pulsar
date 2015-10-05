require 'spec_helper'

RSpec.describe 'Deploy' do
  subject { -> { command } }

  let(:command) do
    `ruby #{RSpec.configuration.pulsar_command} deploy #{arguments}`
  end

  let(:repo)      { RSpec.configuration.pulsar_conf_path }
  let(:arguments) { "--conf-repo #{repo}" }

  context 'via a subcommand named deploy' do
    let(:error) { /Could not find command/ }

    it { is_expected.not_to output(error).to_stderr_from_any_process }
  end

  context 'requires a --conf-repo option' do
    let(:arguments) { nil }
    let(:error)     { /No value provided for required options '--conf-repo'/ }

    it { is_expected.to output(error).to_stderr_from_any_process }

    context 'can be specified via the alias -c' do
      let(:arguments) { "-c #{repo}" }

      it { is_expected.not_to output(error).to_stderr_from_any_process }
    end

    context 'can be specified via the environment variable PULSAR_CONF_REPO' do
      before { ENV['PULSAR_CONF_REPO'] = repo }

      it { is_expected.not_to output(error).to_stderr_from_any_process }
    end
  end

  context 'when succeeds' do
    context 'deploys an application on a stage in the pulsar configuration' do
      context 'from a local folder' do
        context 'leaves the tmp folder empty'
      end

      context 'from a local repository' do
        context 'uncommitted changes' do
          context 'leaves the tmp folder empty'
        end

        context 'committed changes' do
          context 'leaves the tmp folder empty'
        end
      end

      context 'from a remote Git repository' do
        context 'leaves the tmp folder empty'
      end

      context 'from a remote GitHub repository' do
        context 'leaves the tmp folder empty'
      end
    end
  end

  context 'when fails' do
    context 'because of wrong directory'
    context 'because of empty directory'
    context 'because Capistrano failed'
  end
end