require 'spec_helper'

RSpec.describe Pulsar::Deploy do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor::Organizer) }

  context 'organizes interactors' do
    subject { described_class.organized }

    let(:interactors) do
      [
        Pulsar::IdentifyRepositoryLocation,
        Pulsar::IdentifyRepositoryType,
        Pulsar::CreateRunDirs,
        Pulsar::CloneRepository,
        Pulsar::AddApplications,
        Pulsar::CreateCapfile,
        Pulsar::CreateDeployFile,
        Pulsar::CopyEnvironmentFile,
        Pulsar::RunBundleInstall,
        Pulsar::RunCapistrano,
        Pulsar::Cleanup
      ]
    end

    it { is_expected.to eql interactors }
  end
end
