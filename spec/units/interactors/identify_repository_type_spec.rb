require 'spec_helper'

RSpec.describe Pulsar::IdentifyRepositoryType do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.call' do
    subject { described_class.call(repository: repo) }

    let(:repo) { './my-conf' }

    context 'success' do
      before do
        allow(File).to receive(:exist?).and_return(true)
        expect(Rake).to receive(:sh).with("git -C #{repo} status")
      end

      it { is_expected.to be_a_success }

      context 'when the repository' do
        subject { described_class.call(repository: repo).repository_type }

        context 'is a local folder' do
          before { allow(Rake).to receive(:sh).and_return(false) }

          it { is_expected.to eql :local_folder }
        end

        context 'is a local git repository' do
          before { allow(Rake).to receive(:sh).and_return(true) }

          it { is_expected.to eql :local_git }
        end
      end
    end

    context 'failure' do
      context 'when no repository context is passed' do
        subject { described_class.call }

        it { is_expected.to be_a_failure }
      end

      context 'when an exception is triggered' do
        before { allow(Rake).to receive(:sh).and_raise(RuntimeError) }

        it { is_expected.to be_a_failure }
      end
    end
  end
end
