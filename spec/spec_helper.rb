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

  config.add_setting :pulsar_command
  config.add_setting :pulsar_conf_path
  config.add_setting :pulsar_empty_conf_path
  config.add_setting :pulsar_local_conf_repo_path

  config.pulsar_command = File.expand_path('./bin/pulsar')
  config.pulsar_conf_path = File.expand_path('./spec/support/dummies/conf/dir')
  config.pulsar_empty_conf_path = File.expand_path('./spec/support/dummies/conf/empty')
  config.pulsar_local_conf_repo_path = File.expand_path('./spec/support/tmp/dummy-repo')

  config.before(:suite) do
    Dir.chdir('./spec/support/tmp')
  end

  config.after(:each) do
    FileUtils.rm_rf(Dir.glob("#{File.dirname(__FILE__)}/support/tmp/*"))
  end
end
