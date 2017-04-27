require 'spec_helper'

RSpec.describe 'Version' do
  subject { command_output }

  let(:command) do
    Pulsar::Executor.sh("#{RSpec.configuration.pulsar_command} #{arguments}")
  end
  let(:command_output) { command[:output] }
  let(:exit_status)    { command[:status] }
  let(:arguments) { "--version" }

  context 'via a --version flag' do
    let(:version) { "#{Pulsar::VERSION}\n" }

    it { is_expected.to eql version }
    it { expect(exit_status).to eq(0) }
  end
end
