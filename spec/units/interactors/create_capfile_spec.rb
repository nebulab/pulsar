require 'spec_helper'

RSpec.describe Pulsar::CreateCapfile do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.call' do
    subject { command }

    let(:command) { described_class.call(args) }
    let(:cap_path) { "#{Pulsar::PULSAR_TMP}/cap-path" }
    let(:args) do
      {
        config_path: RSpec.configuration.pulsar_conf_path,
        cap_path: cap_path, application: 'blog', applications: { 'blog' => %w(staging) }
      }
    end

    before { FileUtils.mkdir_p(cap_path) }

    context 'success' do
      it { is_expected.to be_a_success }

      context 'creates a Capfile' do
        subject { File }

        it { is_expected.to exist(command.capfile_path) }

        context 'with the required Capistrano path' do
          subject { command.capfile_path }

          it { is_expected.to eql "#{cap_path}/Capfile" }
        end

        context 'with contents combined from pulsar configuration repo' do
          subject { File.read(command.capfile_path) }

          let(:load_recipes) do
            "Dir.glob(\"#{RSpec.configuration.pulsar_conf_path}/recipes/**/*.rake\").each { |r| import r }"
          end

          it { is_expected.to match(/# Defaults Capfile.*# App Defaults Capfile/m) }
          it { is_expected.to include(load_recipes) }
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
