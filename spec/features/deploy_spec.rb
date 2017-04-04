require 'spec_helper'

RSpec.describe 'Deploy' do
  subject { -> { command } }

  let(:command) do
    `DRY_RUN=true #{RSpec.configuration.pulsar_command} deploy #{options} #{arguments}`
  end

  let(:repo)        { RSpec.configuration.pulsar_conf_path }
  let(:options)     { "--conf-repo #{repo}" }
  let(:app)         { 'blog' }
  let(:environment) { 'production' }
  let(:arguments)   { "#{app} #{environment}" }

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

  context 'requires application and environment arguments' do
    let(:app)         { nil }
    let(:environment) { nil }
    let(:error)       { /Usage: "pulsar deploy APPLICATION ENVIRONMENT"/ }

    it { is_expected.to output(error).to_stderr_from_any_process }
  end

  context 'when succeeds' do
    subject { command }

    context 'deploys an application on a environment in the pulsar configuration' do
      let(:output) { "Deployed blog on production!\n" }

      context 'from a local folder' do
        let(:repo) { Dir.mktmpdir }

        before do
          FileUtils.cp_r("#{RSpec.configuration.pulsar_conf_path}/.", repo)
        end

        it { is_expected.to match(output) }

        context 'leaves the tmp folder empty' do
          subject { Dir.glob("#{Pulsar::PULSAR_TMP}/*") }

          before { command }

          it { is_expected.to be_empty }
        end
      end

      context 'from a remote Git repository' do
        let(:repo)        { RSpec.configuration.pulsar_remote_git_conf }
        let(:app)         { 'your_app' }
        let(:environment) { 'staging' }
        let(:output)      { "Deployed your_app on staging!\n" }

        it { is_expected.to match(output) }

        context 'leaves the tmp folder empty' do
          subject { Dir.glob("#{Pulsar::PULSAR_TMP}/*") }

          before { command }

          it { is_expected.to be_empty }
        end
      end

      context 'from a remote GitHub repository' do
        let(:repo)        { RSpec.configuration.pulsar_remote_github_conf }
        let(:app)         { 'your_app' }
        let(:environment) { 'staging' }
        let(:output)      { "Deployed your_app on staging!\n" }

        it { is_expected.to match(output) }

        context 'leaves the tmp folder empty' do
          subject { Dir.glob("#{Pulsar::PULSAR_TMP}/*") }

          before { command }

          it { is_expected.to be_empty }
        end
      end
    end
  end

  context 'when fails' do
    subject { command }

    context 'because of wrong directory' do
      let(:repo) { './some-wrong-directory' }

      it { is_expected.to match("Failed to deploy blog on production.\n") }
    end

    context 'because of empty directory' do
      let(:repo) { RSpec.configuration.pulsar_empty_conf_path }

      it { is_expected.to match("Failed to deploy blog on production.\n") }
      it { is_expected.to match "No application found on repository #{RSpec.configuration.pulsar_empty_conf_path}\n" }
    end

    context 'because Bundler failed' do
      let(:repo) { RSpec.configuration.pulsar_wrong_bundle_conf_path }

      it { is_expected.to match("Failed to deploy blog on production.\n") }
    end

    context 'because Capistrano failed' do
      let(:repo) { RSpec.configuration.pulsar_wrong_cap_conf_path }

      it { is_expected.to match("Failed to deploy blog on production.\n") }
    end

    context 'because the application does not exists in the repository' do
      let(:repo)        { RSpec.configuration.pulsar_conf_path }
      let(:app)         { 'foobuzz' }
      let(:environment) { 'staging' }

      it { is_expected.to match("The application foobuzz does not exist in your repository") }
    end

    context 'because the environment does not exists for the application' do
      let(:repo)        { RSpec.configuration.pulsar_conf_path }
      let(:app)         { 'blog' }
      let(:environment) { 'foobuzz' }

      it { is_expected.to match("The application blog does not have an environment called foobuzz") }

      context 'but \'no application error\' message takes precedence' do
        let(:app) { 'foobuzz' }

        it { is_expected.to match("The application foobuzz does not exist in your repository") }
      end
    end
  end
end
