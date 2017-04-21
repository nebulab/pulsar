require 'spec_helper'

class BasicValidator
  include Interactor
  include Pulsar::Validator
end

class NotNilInteractor
  include Interactor
  include Pulsar::Validator

  validate_context_for! :not_nil_property
end

class MultiplePropertiesInteractor
  include Interactor
  include Pulsar::Validator

  validate_context_for! :not_nil_property
end

class GreaterThanTenInteractor
  include Interactor
  include Pulsar::Validator

  validate_context_for! :greater_than_ten do |prop|
    prop > 10
  end
end

RSpec.describe Pulsar::Validator do
  let(:described_instance) { BasicValidator.new }

  it { expect(described_instance).to respond_to :validate_context! }

  describe '#validate_context!' do

    context 'without block' do
      subject { NotNilInteractor.call initial_context }

      context 'with valid property names' do
        let(:initial_context) { { not_nil_property: true } }

        it { is_expected.to be_a_success }
        it { is_expected.to eql Interactor::Context.new(not_nil_property: true) }
      end


      context 'with multiple property names' do
        subject { MultiplePropertiesInteractor.call initial_context }

        let(:initial_context) { { not_nil_property: true, another_property: true } }

        it { is_expected.to be_a_success }
        it { is_expected.to eql Interactor::Context.new(not_nil_property: true, another_property: true) }

        context 'when fails' do
          let(:initial_context) { { not_nil_property: false, another_property: true } }
          it { is_expected.to be_a_failure }
        end
      end

      context 'with invalid property name' do
        let(:initial_context) { { not_nil_property: nil } }

        it { is_expected.to be_a_failure }
      end
    end

    context 'with block' do
      subject { GreaterThanTenInteractor.call initial_context }
      context 'with valid property' do
        let(:initial_context) { { greater_than_ten: 32 } }

        it { is_expected.to be_a_success }
        it { is_expected.to eql Interactor::Context.new(greater_than_ten: 32) }
      end

      context 'with invalid property' do
        let(:initial_context) { { greater_than_ten: 4 } }

        it { is_expected.to be_a_failure }
      end
    end
  end
end
