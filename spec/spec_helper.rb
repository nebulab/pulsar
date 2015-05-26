require 'rspec'
require 'stringio'
require 'fileutils'
require 'codeclimate-test-reporter'
require 'pulsar'

#
# Code coverage
#
CodeClimate::TestReporter.start

RSpec.configure do |config|
  config.mock_with :rspec
  config.raise_errors_for_deprecations!
  config.alias_example_group_to :feature
  config.alias_example_to :scenario

  config.add_setting :pulsar_command
  config.pulsar_command =  File.expand_path('./bin/pulsar')

  config.before(:suite) do
    Dir.chdir('./spec/support/tmp')
  end

  config.after(:each) do
    FileUtils.rm_rf(Dir.glob("#{File.dirname(__FILE__)}/support/tmp/*"))
  end
end
