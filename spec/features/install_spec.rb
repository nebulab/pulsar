require 'spec_helper'

RSpec.describe 'Install' do
  subject { command }

  let(:command) do
    `ruby #{RSpec.configuration.pulsar_command} install #{arguments}`
  end

  let(:arguments) { nil }

  context 'via a subcommand named install' do
    subject { -> { command } }

    let(:error) { /Could not find command/ }

    it { is_expected.not_to output(error).to_stderr_from_any_process }
  end

  context 'when succeeds' do
    it { is_expected.to match(/Successfully created intial repo!/) }

    context 'creates a directory named pulsar-conf' do
      context 'with the basic pulsar configuration repository' do
        subject(:initial_pulsar_repo) do
          Dir.entries('./../../../lib/pulsar/generators/initial_repo/')
        end

        before { command }

        it { is_expected.to eql Dir.entries('./pulsar-conf') }
      end

      context 'inside the current directory by default' do
        subject { -> { command } }

        it { is_expected.to change { File.exist?('./pulsar-conf') }.from(false) }
      end
    end

    context 'creates a directory named as the passed argument' do
      let(:arguments) { './my-dir' }

      context 'if passed as an argument' do
        subject { -> { command } }

        it { is_expected.to change { File.exist?('./my-dir') }.from(false) }
      end
    end
  end

  context 'when fails' do
    let(:arguments) { '/pulsar-conf' }

    it { is_expected.to match(/Failed to create intial repo./) }

    context 'does not create a directory' do
      subject { -> { command } }

      it { is_expected.not_to change { File.exist?('./my-dir') }.from(false) }
    end
  end
end
