require 'spec_helper'

RSpec.feature 'Install' do
  subject { `ruby #{RSpec.configuration.pulsar_command} install #{arguments}` }

  let(:arguments) { nil }

  scenario 'via a subcommand named install' do
    expect { subject }
      .not_to output(/Could not find command/).to_stderr_from_any_process
  end

  context 'when succeeds' do
    scenario 'says it out loud' do
      is_expected.to match(/Successfully created intial repo!/)
    end

    context 'creates a directory named pulsar-conf' do
      let(:initial_repo) { './../../../lib/pulsar/generators/initial_repo/' }

      scenario 'with the basic pulsar configuration repository' do
        subject
        expect(Dir.entries(initial_repo)).to eql Dir.entries('./pulsar-conf')
      end

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
