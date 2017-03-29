require 'spec_helper'

RSpec.describe Pulsar::CloneRepository do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.call' do
    subject do
      described_class.call(
        config_path: run_path,
        repository: repo,
        repository_type: type
      )
    end

    let(:repo) { './my-conf' }
    let(:run_path) { "#{Pulsar::PULSAR_TMP}/run-#{Time.now.to_f}/conf" }

    context 'success' do
      context 'when repository_type is :folder' do
        let(:type) { :folder }
        let(:repo) { "#{RSpec.configuration.pulsar_conf_path}" }

        before do
          expect(FileUtils).to receive(:cp_r).with("#{repo}/.", run_path).ordered
        end

        it { is_expected.to be_a_success }

        context 'returns a config_path path' do
          subject do
            described_class
              .call(config_path: run_path, repository: repo, repository_type: type)
              .config_path
          end

          it { is_expected.to match run_path }
        end
      end

      context 'when repository_type is a :git' do
        let(:type) { :git }

        before do
          expect(Rake).to receive(:sh)
            .with(/git clone --quiet --depth 1 #{repo} #{run_path}/).ordered
        end

        it { is_expected.to be_a_success }

        context 'returns a config_path path' do
          subject do
            described_class
              .call(config_path: run_path, repository: repo, repository_type: type)
              .config_path
          end

          it { is_expected.to match run_path }
        end
      end

      context 'when repository_type is a :github' do
        let(:type) { :github }
        let(:repo) { 'github-account/my-conf' }

        let(:github_regex) do
          /git clone --quiet --depth 1 git@github.com:#{repo}.git #{run_path}/
        end

        before do
          expect(Rake).to receive(:sh).with(github_regex).ordered
        end

        it { is_expected.to be_a_success }

        context 'returns a config_path path' do
          subject do
            described_class
              .call(config_path: run_path, repository: repo, repository_type: type)
              .config_path
          end

          it { is_expected.to match run_path }
        end
      end
    end

    context 'failure' do
      context 'when no config_path context is passed' do
        subject do
          described_class.call(repository: './some-path', repository_type: :something)
        end

        it { is_expected.to be_a_failure }
      end

      context 'when no repository context is passed' do
        subject do
          described_class.call(config_path: './some-path', repository_type: :something)
        end

        it { is_expected.to be_a_failure }
      end

      context 'when no repository_type context is passed' do
        subject do
          described_class.call(config_path: './some-path', repository: './some-path')
        end

        it { is_expected.to be_a_failure }
      end

      context 'when an exception is triggered' do
        let(:type) { :folder }

        before { allow(FileUtils).to receive(:cp_r).and_raise(RuntimeError) }

        it { is_expected.to be_a_failure }
      end
    end
  end
end
