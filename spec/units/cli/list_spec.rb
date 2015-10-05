require 'spec_helper'

RSpec.describe Pulsar::CLI do
  subject { described_class.new }

  context '#list' do
    let(:result) { spy }
    let(:repo)   { './conf_repo' }

    before do
      allow($stdout).to receive(:puts)
      allow(Pulsar::List).to receive(:call).and_return(result)
    end

    context 'when using --conf-repo' do
      before do
        allow(subject).to receive(:options).and_return(conf_repo: repo)
      end

      it 'calls Pulsar::List' do
        subject.list

        expect(Pulsar::List)
          .to have_received(:call).with(repository: repo)
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

    context 'when using configuration file' do
      before do
        allow(subject).to receive(:options).and_return({})
      end

      around do |example|
        old_const = Pulsar::PULSAR_CONF
        Pulsar.send(:remove_const, 'PULSAR_CONF')
        Pulsar::PULSAR_CONF = RSpec.configuration.pulsar_dotenv_conf_path
        example.run
        Pulsar.send(:remove_const, 'PULSAR_CONF')
        Pulsar::PULSAR_CONF = old_const
      end

      it 'calls Pulsar::List' do
        subject.list

        expect(Pulsar::List)
          .to have_received(:call).with(repository: repo)
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

    context 'when using PULSAR_CONF_REPO' do
      before do
        allow(subject).to receive(:options).and_return({})
        ENV['PULSAR_CONF_REPO'] = repo
      end

      it 'calls Pulsar::List' do
        subject.list

        expect(Pulsar::List)
          .to have_received(:call).with(repository: repo)
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
end
