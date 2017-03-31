require 'spec_helper'

RSpec.describe Pulsar::AddApplications do
  subject { described_class.new }

  it { is_expected.to be_kind_of(Interactor) }

  describe '.call' do
    subject { described_class.call(config_path: './my-conf') }

    before do
      allow(Dir).to receive(:[])
        .and_return(%w(./blog/), %w(Capfile deploy.rb production.rb staging.rb))
    end

    context 'success' do
      it { is_expected.to be_a_success }

      context 'returns a list of applications and stages' do
        subject { described_class.call(config_path: './my-conf').applications }

        it { is_expected.to eql('blog' => %w(production staging)) }
      end
    end

    context 'failure' do
      context 'when no config_path context is passed' do
        subject { described_class.call }

        it { is_expected.to be_a_failure }
      end

      context 'when an exception is triggered' do
        before { allow(Dir).to receive(:[]).and_raise(RuntimeError) }

        it { is_expected.to be_a_failure }
      end

      context 'when there are no applications' do
        before { allow(Dir).to receive(:[]).and_return([]) }

        it { is_expected.to be_a_failure }
      end
    end
  end
end
