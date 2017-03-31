require 'spec_helper'

RSpec.describe 'Version' do
  subject { command }

  let(:command) do
    `#{RSpec.configuration.pulsar_command} #{arguments}`
  end

  let(:arguments) { "--version" }

  context 'via a --version flag' do
    let(:version) { "#{Pulsar::VERSION}\n" }

    it { is_expected.to eql version }
  end
end
