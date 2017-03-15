require 'spec_helper'

RSpec.describe Pulsar::RunBundleInstall do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.success' do
    subject do
      described_class.new(config_path: './config-path', bundle_path: './bundle-path')
    end

    let(:bundle_env) do
      'BUNDLE_GEMFILE=./config-path/Gemfile BUNDLE_PATH=./bundle-path'
    end
    let(:bundle_install_cmd) do
      "#{bundle_env} bundle check || #{bundle_env} bundle install"
    end

    before do
      allow(subject).to receive(:system)
      subject.run
    end

    it { is_expected.to have_received(:system).with(bundle_install_cmd) }
  end

  context 'failure' do
    context 'when no context is passed' do
      subject { described_class.call }

      it { is_expected.to be_a_failure }
    end

    context 'when no config_path context is passed' do
      subject { described_class.call(bundle_path: './some-path') }

      it { is_expected.to be_a_failure }
    end

    context 'when no bundle_path context is passed' do
      subject { described_class.call(config_path: './some-path') }

      it { is_expected.to be_a_failure }
    end

    context 'when an exception is triggered' do
      subject do
        described_class.new(config_path: './config-path', bundle_path: './bundle-path')
      end

      before do
        allow(subject).to receive(:system).and_raise(RuntimeError)
        subject.run
      end

      it { expect(subject.context).to be_a_failure }
    end
  end
end
