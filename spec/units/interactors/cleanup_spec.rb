require 'spec_helper'

RSpec.describe Pulsar::Cleanup do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.call' do
    subject { FileUtils }

    let(:config_path) { './some-path' }

    before do
      allow(subject).to receive(:rm_rf)

      described_class.call(config_path: config_path)
    end

    it { is_expected.to have_received(:rm_rf).with(config_path) }
  end
end
