require 'spec_helper'

class TestInteractor
  include Pulsar::ExtendedInteractor
end

RSpec.describe TestInteractor do
  describe 'class methods' do
    subject { described_class }

    it { is_expected.to respond_to :validate_context_for }
    it { expect(subject.ancestors).to include Pulsar::ExtendedInteractor }

    describe '#validate_context_for' do
      context 'without block' do
        subject { described_class.new }
        before do
          described_class.validate_context_for :property
        end

        it { is_expected.to respond_to :validate_context_for_property }

        context 'success' do
          subject { described_class.call initial_context }
          let(:initial_context) { { property: true } }

          it { is_expected.to eql Interactor::Context.new(property: true) }
        end

        context 'fail' do
          subject { described_class.call initial_context }
          let(:initial_context) { { property: nil } }

          it { is_expected.to be_a_failure }
        end
      end

      context 'with block' do
        subject { described_class.new }
        before do
          described_class.validate_context_for :property do |property|
            property > 10
          end
        end

        it { is_expected.to respond_to :validate_context_for_property }

        context 'success' do
          subject { described_class.call initial_context }
          let(:initial_context) { { property: 32 } }

          it { is_expected.to eql Interactor::Context.new(property: 32) }
        end

        context 'fail' do
          subject { described_class.call initial_context }
          let(:initial_context) { { property: 4 } }

          it { is_expected.to be_a_failure }
        end
      end
    end
  end
end
