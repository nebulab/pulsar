require 'spec_helper'

RSpec.describe Pulsar::IdentifyRepositoryType do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.call' do
    subject { described_class.call(args) }

    let(:repo)     { './my-conf' }
    let(:location) { :local }
    let(:args)     { { repository: repo, repository_location: location } }

    context 'success' do
      context 'when local' do
        it { is_expected.to be_a_success }

        context 'the configuration repository' do
          subject { described_class.call(args).repository_type }

          context 'is a folder' do
            it { is_expected.to eql :folder }
          end
        end
      end

      context 'when remote' do
        let(:location) { :remote }

        it { is_expected.to be_a_success }

        context 'the configuration repository' do
          subject { described_class.call(args).repository_type }

          context 'is a git repository' do
            it { is_expected.to eql :git }
          end

          context 'is a GitHub repository' do
            let(:repo) { 'github-account/my-conf' }

            it { is_expected.to eql :github }
          end
        end
      end
    end

    context 'failure' do
      context 'when no repository context is passed' do
        subject { described_class.call(repository_location: :local) }

        it { is_expected.to be_a_failure }
      end

      context 'when no repository_location context is passed' do
        subject { described_class.call(repository: repo) }

        it { is_expected.to be_a_failure }
      end
    end
  end
end
