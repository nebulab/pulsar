require 'spec_helper'

RSpec.describe Pulsar::Install do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.call' do
    subject { described_class.call(directory: './pulsar-conf') }

    let(:initial_repo) { './../../../lib/pulsar/generators/initial_repo/' }

    context 'success' do
      before { allow(FileUtils).to receive(:cp_r) }

      it { is_expected.to be_a_success }

      it 'copies a template directory to destination' do
        subject

        expect(FileUtils)
          .to have_received(:cp_r)
          .with(File.expand_path(initial_repo), subject.directory)
      end
    end

    context 'failure' do
      context 'when no directory context is passed' do
        subject { described_class.call }

        it { is_expected.to be_a_failure }
      end

      context 'when an exception is triggered' do
        before { allow(FileUtils).to receive(:cp_r).and_raise(RuntimeError) }

        it { is_expected.to be_a_failure }
      end
    end
  end
end
