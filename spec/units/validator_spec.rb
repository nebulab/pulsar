require 'spec_helper'

class NotNilInteractor
  include Interactor
  include Pulsar::Validator

  validate_context_for! :not_nil_property
end

RSpec.describe Pulsar::Validator do
  let(:described_instance) { NotNilInteractor.new }

  it { expect(described_instance).to respond_to :validate_context! }

  describe '#validate_context!' do
    subject { NotNilInteractor.call initial_context }

    context 'with valid property name' do
      let(:initial_context) { { not_nil_property: true } }

      it { is_expected.to be_a_success }
      it { is_expected.to eql Interactor::Context.new(not_nil_property: true) }
    end

    context 'with invalid property name' do
      let(:initial_context) { { not_nil_property: nil } }

      it { is_expected.to be_a_failure }
    end
  end
end
