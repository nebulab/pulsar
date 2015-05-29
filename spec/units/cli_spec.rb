require 'spec_helper'

RSpec.describe Pulsar::CLI do
  subject { described_class.new }

  context '#install' do
    let(:result) { spy }

    before do
      allow(Pulsar::Install).to receive(:call).and_return(result)
      allow($stdout).to receive(:puts)
    end

    it 'calls Pulsar::Install with ./pulsar-conf by default' do
      subject.install

      expect(Pulsar::Install)
        .to have_received(:call).with(directory: './pulsar-conf')
    end

    it 'calls Pulsar::Install with an argument' do
      subject.install('./a-dir')

      expect(Pulsar::Install)
        .to have_received(:call).with(directory: './a-dir')
    end

    context 'success' do
      let(:result) { spy(success?: true) }

      it 'outputs success text' do
        expect { subject.install }
          .to output(/Successfully created intial repo!/).to_stdout
      end
    end

    context 'failure' do
      let(:result) { spy(success?: false) }

      it 'outputs failure text' do
        expect { subject.install }
          .to output(/Failed to create intial repo./).to_stdout
      end
    end
  end

  context '#list' do
    let(:result) { spy }

    before do
      allow($stdout).to receive(:puts)
      allow(Pulsar::List).to receive(:call).and_return(result)
      allow(subject).to receive(:options).and_return(conf_repo: './conf')
    end

    it 'calls Pulsar::List' do
      subject.list

      expect(Pulsar::List)
        .to have_received(:call).with(repository: './conf')
    end

    context 'success' do
      let(:applications) { 'blog: staging' }
      let(:result) { spy(success?: true, applications: applications) }

      it 'outputs a list of applications and stages' do
        expect { subject.list }
          .to output(/#{applications}/).to_stdout
      end
    end

    context 'failure' do
      let(:result) { spy(success?: false) }

      it 'outputs failure text' do
        expect { subject.list }
          .to output(/Failed to list application and stages./).to_stdout
      end
    end
  end
end
