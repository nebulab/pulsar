require 'rspec'
require 'stringio'
require 'fileutils'
require 'timecop'
require 'tmpdir'
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
  config.add_setting :pulsar_wrong_cap_conf_path
  config.add_setting :pulsar_wrong_bundle_conf_path
  config.add_setting :pulsar_dotenv_conf_path
  config.add_setting :pulsar_local_conf_repo_path
  config.add_setting :pulsar_remote_git_conf
  config.add_setting :pulsar_remote_github_conf

  config.pulsar_command = "ruby -Ilib #{File.expand_path('./exe/pulsar')}"
  config.pulsar_conf_path = File.expand_path('./spec/support/dummies/conf/dir')
  config.pulsar_empty_conf_path = File.expand_path('./spec/support/dummies/conf/empty')
  config.pulsar_wrong_cap_conf_path = File.expand_path('./spec/support/dummies/conf/wrong_cap')
  config.pulsar_wrong_bundle_conf_path = File.expand_path('./spec/support/dummies/conf/wrong_bundle')
  config.pulsar_dotenv_conf_path = File.expand_path('./spec/support/dummies/conf/dotenv')
  config.pulsar_local_conf_repo_path = File.expand_path('./spec/support/tmp/dummy-repo')
  config.pulsar_remote_git_conf = 'git@github.com:nebulab/pulsar-conf-demo.git'
  config.pulsar_remote_github_conf = 'nebulab/pulsar-conf-demo'

  config.before(:suite) do
    Dir.chdir('./spec/support/tmp')
  end

  config.before(:each) do
    ENV.delete_if { |name, _| name =~ /^PULSAR_/ }
  end

  config.after(:each) do
    FileUtils.rm_rf(Dir.glob("#{File.dirname(__FILE__)}/support/tmp/*"))
    FileUtils.rm_rf(Dir.glob("#{Pulsar::PULSAR_TMP}/*"))
  end
end
