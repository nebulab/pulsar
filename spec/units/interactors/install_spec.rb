require 'spec_helper'

RSpec.describe Pulsar::Install do
  subject { Pulsar::Install.call(directory: './pulsar-conf') }

  let(:initial_repo) { './../../../lib/pulsar/generators/initial_repo/' }

  describe '.call' do
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
      before { allow(FileUtils).to receive(:cp_r).and_raise(RuntimeError) }

      it { is_expected.to be_a_failure }
    end
  end
end
