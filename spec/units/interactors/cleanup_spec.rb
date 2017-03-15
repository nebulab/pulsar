require 'spec_helper'

RSpec.describe Pulsar::Cleanup do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.call' do
    subject { FileUtils }

    let(:run_path) { './some-path' }

    before do
      allow(subject).to receive(:rm_rf)

      described_class.call(run_path: run_path)
    end

    it { is_expected.to have_received(:rm_rf).with(run_path) }
  end
end
