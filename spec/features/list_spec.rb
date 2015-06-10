require 'spec_helper'

RSpec.describe 'List' do
  subject { -> { command } }

  let(:command) do
    `ruby #{RSpec.configuration.pulsar_command} list #{arguments}`
  end

  let(:repo)      { RSpec.configuration.pulsar_conf_path }
  let(:arguments) { "--conf-repo #{repo}" }

  context 'via a subcommand named list' do
    let(:error) { /Could not find command/ }

    it { is_expected.not_to output(error).to_stderr_from_any_process }
  end

  context 'requires a --conf-repo option' do
    let(:arguments) { nil }
    let(:error)     { /No value provided for required options '--conf-repo'/ }

    it { is_expected.to output(error).to_stderr_from_any_process }
  end

  context 'when succeeds' do
    subject { command }

    context 'lists applications in the pulsar configuration' do
      let(:output) { /blog: production, staging\necommerce: staging/ }

      context 'from a local folder' do
        it { is_expected.to match(output) }
      end

      context 'from a local repository' do
        let(:repo) { RSpec.configuration.pulsar_local_conf_repo_path }

        before do
          FileUtils.cp_r(RSpec.configuration.pulsar_conf_path, repo)
          `git init #{repo}`
        end

        context 'uncommitted changes' do
          it { is_expected.not_to match(output) }
        end

        context 'committed changes' do
          before do
            FileUtils.cd(repo) do
              `git add .`
              `git commit -m 'Initial Commit'`
            end
          end

          it { is_expected.to match(output) }
        end
      end

      context 'from a GitHub repository'
    end
  end

  context 'when fails' do
    subject { command }

    context 'because of wrong directory' do
      let(:repo) { './some-wrong-directory' }

      it { is_expected.to match(/Failed to list application and stages./) }
    end

    context 'because of empty directory' do
      let(:repo) { RSpec.configuration.pulsar_empty_conf_path }

      it { is_expected.to match(/Failed to list application and stages./) }
    end
  end
end
