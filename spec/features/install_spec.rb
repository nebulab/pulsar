require 'spec_helper'

RSpec.describe 'Install' do
  subject { command_output }

  let(:command) do
    Pulsar::Executor.sh("#{RSpec.configuration.pulsar_command} install #{arguments}")
  end
  let(:command_output) { command[:output] }
  let(:exit_status)    { command[:status] }

  let(:arguments) { nil }

  context 'via a subcommand named install' do
    subject { -> { command_output } }

    let(:error) { /Could not find command/ }

    it { is_expected.not_to output(error).to_stderr_from_any_process }
    it { expect(exit_status).to eq(0) }
  end

  context 'when succeeds' do
    it { is_expected.to eql "Successfully created intial repo!\n" }

    context 'creates a directory' do
      subject { -> { command_output } }

      it { expect(exit_status).to eq(0) }

      context 'with the basic configuration' do
        subject(:initial_pulsar_repo) do
          Dir.entries('./../../../lib/pulsar/generators/initial_repo/')
        end

        before { command_output }

        it 'contains the initial directory structure' do
          is_expected.to eql Dir.entries('./pulsar-conf')
        end
      end

      context 'inside the current directory by default' do
        it 'named pulsar-conf' do
          is_expected
            .to change { File.exist?('./pulsar-conf') }.from(false).to(true)
        end
      end

      context 'inside a directory passed as argument' do
        let(:arguments) { './my-dir' }

        it 'named as the argument' do
          is_expected.to change { File.exist?('./my-dir') }.from(false).to(true)
        end
      end
    end
  end

  context 'when fails' do
    let(:arguments) { '/pulsar-conf' }

    it { is_expected.to match "Failed to create intial repo.\n" }

    context 'does not create a directory' do
      subject { -> { command_output } }

      it { is_expected.not_to change { File.exist?('./my-dir') }.from(false) }
      it { expect(exit_status).to eq(1) }
    end
  end
end
