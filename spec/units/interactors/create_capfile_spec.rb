require 'spec_helper'

RSpec.describe Pulsar::CreateCapfile do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.call' do
    subject { command }

    let(:command) { described_class.call(args) }
    let(:args) do
      {
        config_path: RSpec.configuration.pulsar_conf_path,
        application: 'blog', environment: 'production'
      }
    end

    context 'success' do
      it { is_expected.to be_a_success }

      context 'creates a Capfile' do
        subject { File }

        it { is_expected.to exist(command.capistrano_path) }
        it { is_expected.to exist(command.capfile_path) }

        context 'with contents combined from pulsar configuration repo' do
          subject { File.read(command.capfile_path) }

          it { is_expected.to match(/# Defaults Capfile\n# App Defaults Capfile/) }
          it { is_expected.to include("Dir.glob(\"**/*.rake\").each { |r| import r }") }
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

      context 'when no environment context is passed' do
        subject { described_class.call(config_path: './my-conf', application: 'blog') }

        it { is_expected.to be_a_failure }
      end

      context 'when an exception is triggered' do
        before { allow(FileUtils).to receive(:mkdir_p).and_raise(RuntimeError) }

        it { is_expected.to be_a_failure }
      end
    end
  end
end
