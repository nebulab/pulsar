require 'spec_helper'

RSpec.describe Pulsar::IdentifyRepositoryLocation do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.call' do
    subject { described_class.call(repository: repo) }

    let(:repo) { './my-conf' }

    context 'success' do
      before { allow(File).to receive(:exist?) }

      it { is_expected.to be_a_success }

      context 'when the repository' do
        subject { described_class.call(repository: repo).repository_location }

        context 'is a local folder' do
          before { allow(File).to receive(:exist?).and_return(true) }

          it { is_expected.to eql :local }
        end

        context 'is a local git repository' do
          before { allow(File).to receive(:exist?).and_return(false) }

          it { is_expected.to eql :remote }
        end
      end
    end

    context 'failure' do
      context 'when no repository context is passed' do
        subject { described_class.call }

        it { is_expected.to be_a_failure }
      end

      context 'when an exception is triggered' do
        before { allow(File).to receive(:exist?).and_raise(RuntimeError) }

        it { is_expected.to be_a_failure }
      end
    end
  end
end
