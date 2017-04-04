require 'spec_helper'

RSpec.describe Pulsar::CLI do
  subject { Pulsar::List }

  let(:described_instance) { described_class.new }
  let(:fail_text) { /Failed to list application and environments./ }

  context '#list' do
    let(:result) { spy }
    let(:repo)   { './conf_repo' }

    before do
      allow($stdout).to receive(:puts)
      allow(Pulsar::List).to receive(:call).and_return(result)
    end

    context 'when using --conf-repo' do
      before do
        allow(described_instance)
          .to receive(:options).and_return(conf_repo: repo)
        described_instance.list
      end

      it { is_expected.to have_received(:call).with(repository: repo) }

      context 'success' do
        subject { -> { described_instance.list } }

        let(:applications) { { 'blog' => %w(staging) } }
        let(:result) { spy(success?: true, applications: applications) }

        it { is_expected.to output(/blog: staging/).to_stdout }
      end

      context 'failure' do
        subject { -> { described_instance.list } }

        let(:result) { spy(success?: false) }

        it { is_expected.to output(fail_text).to_stdout }
      end
    end

    context 'when using configuration file' do
      before do
        allow(described_instance).to receive(:options).and_return({})
        described_instance.list
      end

      around do |example|
        old_const = Pulsar::PULSAR_CONF
        Pulsar.send(:remove_const, 'PULSAR_CONF')
        Pulsar::PULSAR_CONF = RSpec.configuration.pulsar_dotenv_conf_path
        example.run
        Pulsar.send(:remove_const, 'PULSAR_CONF')
        Pulsar::PULSAR_CONF = old_const
      end

      it { is_expected.to have_received(:call).with(repository: repo) }

      context 'success' do
        subject { -> { described_instance.list } }

        let(:applications) { { 'blog' => %w(staging) } }
        let(:result) { spy(success?: true, applications: applications) }

        it { is_expected.to output(/blog: staging/).to_stdout }
      end

      context 'failure' do
        subject { -> { described_instance.list } }

        let(:result) { spy(success?: false) }

        it { is_expected.to output(fail_text).to_stdout }
      end
    end

    context 'when using PULSAR_CONF_REPO' do
      before do
        allow(described_instance).to receive(:options).and_return({})
        ENV['PULSAR_CONF_REPO'] = repo
        described_instance.list
      end

      it { is_expected.to have_received(:call).with(repository: repo) }

      context 'success' do
        subject { -> { described_instance.list } }

        let(:applications) { { 'blog' => %w(staging) } }
        let(:result) { spy(success?: true, applications: applications) }

        it { is_expected.to output(/blog: staging/).to_stdout }
      end

      context 'failure' do
        subject { -> { described_instance.list } }

        let(:result) { spy(success?: false) }

        it { is_expected.to output(fail_text).to_stdout }
      end
    end
  end
end
