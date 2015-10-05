require 'spec_helper'

RSpec.describe 'Pulsar Constants' do
  context Pulsar::PULSAR_HOME do
    subject { Pulsar::PULSAR_HOME }

    it { is_expected.to eql File.expand_path('~/.pulsar') }
  end

  context Pulsar::PULSAR_TMP do
    subject { Pulsar::PULSAR_TMP }

    it { is_expected.to eql "#{Pulsar::PULSAR_HOME}/tmp" }
  end

  context Pulsar::PULSAR_CONF do
    subject { Pulsar::PULSAR_CONF }

    it { is_expected.to eql "#{Pulsar::PULSAR_HOME}/config" }
  end
end
