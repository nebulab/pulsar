require 'spec_helper'

RSpec.describe Pulsar::CopyEnvironmentFile do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.call' do
    subject { command }

    let(:command) { described_class.call(args) }
    let(:cap_path) { "#{Pulsar::PULSAR_TMP}/cap-path" }
    let(:args) do
      {
        config_path: RSpec.configuration.pulsar_conf_path,
        cap_path: cap_path,
        applications: { 'blog' => %w(production staging) },
        application: 'blog',
        environment: 'production'
      }
    end

    context 'success' do
      it { is_expected.to be_a_success }

      context 'creates a Capfile' do
        subject { File }

        it { is_expected.to exist(command.environment_file_path) }

        context 'with the required Capistrano path' do
          subject { command.environment_file_path }

          it { is_expected.to eql "#{cap_path}/config/deploy/production.rb" }
        end

        context 'with contents combined from pulsar configuration repo' do
          subject { File.read(command.environment_file_path) }

          it { is_expected.to match(/# Production config/) }
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

      context 'when no environment context is passed' do
        subject do
          described_class.call(
            cap_path: './some-path', config_path: './my-conf', application: 'blog'
          )
        end

        it { is_expected.to be_a_failure }
      end

      context 'when an exception is triggered' do
        before { allow(FileUtils).to receive(:mkdir_p).and_raise(RuntimeError) }

        it { is_expected.to be_a_failure }
      end
    end
  end
end
