require 'spec_helper'

RSpec.describe Pulsar::CreateDeployFile do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.call' do
    subject { command }

    let(:command) { described_class.call(args) }
    let(:cap_path) { "#{Pulsar::PULSAR_TMP}/cap-path" }
    let(:args) do
      {
        config_path: RSpec.configuration.pulsar_conf_path,
        cap_path: cap_path, application: 'blog'
      }
    end

    before { FileUtils.mkdir_p(cap_path) }

    context 'success' do
      it { is_expected.to be_a_success }

      context 'creates a Capfile' do
        subject { File }

        it { is_expected.to exist(command.deploy_file_path) }

        context 'with contents combined from pulsar configuration repo' do
          subject { File.read(command.deploy_file_path) }

          it { is_expected.to match(/# Defaults deployrb\n# App Defaults deployrb/) }
        end
      end
    end

    context 'failure' do
      context 'when no config_path context is passed' do
        subject { described_class.call }

        it { is_expected.to be_a_failure }
      end

      context 'when no application context is passed' do
        subject { described_class.call(config_path: './my-conf') }

        it { is_expected.to be_a_failure }
      end

      context 'when no cap_path context is passed' do
        subject do
          described_class.call(config_path: './my-conf', application: 'blog')
        end

        it { is_expected.to be_a_failure }
      end

      context 'when an exception is triggered' do
        before { allow(FileUtils).to receive(:touch).and_raise(RuntimeError) }

        it { is_expected.to be_a_failure }
      end
    end
  end
end
