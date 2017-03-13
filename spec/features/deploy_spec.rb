require 'spec_helper'

RSpec.describe 'Deploy' do
  subject { -> { command } }

  let(:command) do
    `ruby #{RSpec.configuration.pulsar_command} deploy #{options} #{arguments}`
  end

  let(:repo)      { RSpec.configuration.pulsar_conf_path }
  let(:options)   { "--conf-repo #{repo}" }
  let(:arguments) { 'blog production' }

  context 'via a subcommand named deploy' do
    let(:error) { /Could not find command/ }

    it { is_expected.not_to output(error).to_stderr_from_any_process }
  end

  context 'requires a --conf-repo option' do
    let(:options) { nil }
    let(:error)   { /No value provided for required options '--conf-repo'/ }

    it { is_expected.to output(error).to_stderr_from_any_process }

    context 'can be specified via the alias -c' do
      let(:options) { "-c #{repo}" }

      it { is_expected.not_to output(error).to_stderr_from_any_process }
    end

    context 'can be specified via the environment variable PULSAR_CONF_REPO' do
      before { ENV['PULSAR_CONF_REPO'] = repo }

      it { is_expected.not_to output(error).to_stderr_from_any_process }
    end
  end

  context 'requires application and stage arguments' do
    let(:arguments) { nil }
    let(:error)     { /Usage: "pulsar deploy APPLICATION STAGE"/ }

    it { is_expected.to output(error).to_stderr_from_any_process }
  end

  context 'when succeeds' do
    subject { command }

    context 'deploys an application on a stage in the pulsar configuration' do
      let(:output) { "blog deployed to production!\n" }

      context 'from a local folder' do
        pending { is_expected.to eql(output) }

        context 'leaves the tmp folder empty' do
          subject { Dir.glob("#{Pulsar::PULSAR_TMP}/*") }

          before { command }

          it { is_expected.to be_empty }
        end
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
