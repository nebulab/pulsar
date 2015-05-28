require 'spec_helper'

RSpec.feature 'Install' do
  subject { `ruby #{RSpec.configuration.pulsar_command} install #{arguments}` }

  let(:arguments) { nil }

  scenario 'is run via a command named install' do
    is_expected.not_to match(/Could not find command/)
  end

  context 'when succeeds' do
    scenario 'says it out loud' do
      is_expected.to match(/Successfully created intial repo!/)
    end

    context 'creates a directory named pulsar-conf' do
      scenario 'with the basic pulsar configuration repository'

      scenario 'inside the current directory by default' do
        expect { subject }
          .to change { File.exist?('./pulsar-conf') }.from(false).to(true)
      end
    end

    context 'creates a directory named as the passed argument' do
      let(:arguments) { './my-dir' }

      scenario 'if passed as an argument' do
        expect { subject }
          .to change { File.exist?('./my-dir') }.from(false).to(true)
      end
    end
  end

  context 'when fails' do
    let(:arguments) { '/pulsar-conf' }

    scenario 'says it out loud' do
      is_expected.to match(/Failed to create intial repo./)
    end

    scenario 'does not create a directory' do
      expect { subject }
        .not_to change { File.exist?('./my-dir') }.from(false)
    end
  end
end
