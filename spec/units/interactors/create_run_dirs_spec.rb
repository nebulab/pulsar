require 'spec_helper'

RSpec.describe Pulsar::CreateRunDirs do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.success' do
    around do |example|
      Timecop.freeze { example.run }
    end

    context 'uses a timestamp' do
      subject { described_class.call.timestamp }

      it { is_expected.to eql Time.now.to_f }
    end

    context 'creates some folders' do
      subject { File }

      let(:command) { described_class.call }

      it { is_expected.to be_directory(command.run_path) }
      it { is_expected.to be_directory(command.config_path) }
      it { is_expected.to be_directory(command.cap_path) }
    end
  end

  describe '.rollback' do
    subject { FileUtils }

    let(:run_path) { '~/.pulsar/tmp/run' }

    before do
      allow(subject).to receive(:rm_rf)
      allow_any_instance_of(Interactor::Context)
        .to receive(:run_path).and_return(run_path)

      described_class.new.rollback
    end

    it { is_expected.to have_received(:rm_rf).with(run_path) }
  end
end
