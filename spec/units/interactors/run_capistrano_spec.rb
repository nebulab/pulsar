require 'spec_helper'

RSpec.describe Pulsar::RunCapistrano do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.success' do
    subject do
      described_class.new(
        cap_path: RSpec.configuration.pulsar_conf_path, config_path: './config-path',
        bundle_path: './bundle-path', environment: 'production'
      )
    end

    let(:cap_cmd) { "cap production deploy" }
    let(:bundle_cmd) do
      "BUNDLE_GEMFILE=./config-path/Gemfile BUNDLE_PATH=./bundle-path bundle exec"
    end

    before do
      allow(Rake).to receive(:sh).and_return(true)
      subject.run
    end

    it { expect(Rake).to have_received(:sh).with("#{bundle_cmd} #{cap_cmd}") }
  end

  context 'failure' do
    context 'when no context is passed' do
      subject { described_class.call }

      it { is_expected.to be_a_failure }
    end

    context 'when no cap_path context is passed' do
      subject do
        described_class.call(
          config_path: './config-path', bundle_path: './bundle-path',
          environment: 'production'
        )
      end

      it { is_expected.to be_a_failure }
    end

    context 'when no environment context is passed' do
      subject do
        described_class.call(
          cap_path: './cap-path', config_path: './config-path',
          bundle_path: './bundle-path'
        )
      end

      it { is_expected.to be_a_failure }
    end
    context 'when no bundle_path context is passed' do
      subject do
        described_class.call(
          cap_path: './cap-path', config_path: './config-path',
          environment: 'production'
        )
      end

      it { is_expected.to be_a_failure }
    end

    context 'when no config_path context is passed' do
      subject do
        described_class.call(
          cap_path: './cap-path', environment: 'production',
          bundle_path: './bundle-path'
        )
      end

      it { is_expected.to be_a_failure }
    end

    context 'when an exception is triggered' do
      subject do
        described_class.call(
          cap_path: './cap-path', config_path: './config-path',
          bundle_path: './bundle-path', environment: 'production'
        )
      end

      before { allow(Dir).to receive(:chdir).and_raise(RuntimeError) }

      it { is_expected.to be_a_failure }
    end
  end
end
