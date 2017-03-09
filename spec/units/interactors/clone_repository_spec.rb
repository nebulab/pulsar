require 'spec_helper'

RSpec.describe Pulsar::CloneRepository do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.call' do
    subject { described_class.call(repository: repo, repository_type: type) }

    let(:repo) { './my-conf' }

    context 'success' do
      let(:tmp_path)   { Pulsar::PULSAR_TMP }
      let(:tmp_config) { %r{#{tmp_path}\/conf-\d+\.\d+} }

      before { expect(FileUtils).to receive(:mkdir_p).with(tmp_path).ordered }

      context 'when repository_type is :folder' do
        let(:type) { :folder }

        before do
          expect(FileUtils).to receive(:cp_r).with(repo, tmp_config).ordered
        end

        it { is_expected.to be_a_success }

        context 'returns a config_path path' do
          subject do
            described_class
              .call(repository: repo, repository_type: type).config_path
          end

          it { is_expected.to match tmp_config }
        end
      end

      context 'when repository_type is a :git' do
        let(:type) { :git }

        before do
          expect(Rake).to receive(:sh)
            .with(/git clone --quiet --depth 1 #{repo} #{tmp_config}/).ordered
        end

        it { is_expected.to be_a_success }

        context 'returns a config_path path' do
          subject do
            described_class
              .call(repository: repo, repository_type: type).config_path
          end

          it { is_expected.to match tmp_config }
        end
      end

      context 'when repository_type is a :github' do
        let(:type) { :github }
        let(:repo) { 'github-account/my-conf' }

        let(:github_regex) do
          /git clone --quiet --depth 1 git@github.com:#{repo}.git #{tmp_config}/
        end

        before do
          expect(Rake).to receive(:sh).with(github_regex).ordered
        end

        it { is_expected.to be_a_success }

        context 'returns a config_path path' do
          subject do
            described_class
              .call(repository: repo, repository_type: type).config_path
          end

          it { is_expected.to match tmp_config }
        end
      end
    end

    context 'failure' do
      context 'when no repository context is passed' do
        subject { described_class.call(repository_type: :something) }

        it { is_expected.to be_a_failure }
      end

      context 'when no repository_type context is passed' do
        subject { described_class.call(repository: './some-path') }

        it { is_expected.to be_a_failure }
      end

      context 'when an exception is triggered' do
        let(:type) { :folder }

        before { allow(FileUtils).to receive(:cp_r).and_raise(RuntimeError) }

        it { is_expected.to be_a_failure }
      end
    end
  end

  describe '.rollback' do
    subject { FileUtils }

    let(:config_path) { '~/.pulsar/tmp/config' }

    before do
      allow(subject).to receive(:rm_rf)
      allow_any_instance_of(Interactor::Context)
        .to receive(:config_path).and_return(config_path)

      described_class.new.rollback
    end

    it { is_expected.to have_received(:rm_rf).with(config_path) }
  end
end
