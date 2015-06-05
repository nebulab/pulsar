require 'spec_helper'

RSpec.describe Pulsar::List do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor::Organizer) }

  context 'organizes interactors' do
    subject { described_class.organized }

    it { is_expected.to eql [Pulsar::AddApplications] }
  end
end
