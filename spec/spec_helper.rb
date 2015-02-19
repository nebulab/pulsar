require "rspec"
require "stringio"
require "fileutils"
require "codeclimate-test-reporter"
require "pulsar"
require "pulsar/commands/main"
require "pulsar/commands/utils"

#
# Code coverage
#
CodeClimate::TestReporter.start

#
# Require all helper modules
#
Dir[File.join(File.dirname(__FILE__), 'support/modules/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.raise_errors_for_deprecations!

  config.include Helpers
  config.include OutputCapture

  config.before(:each) do
    dummy_dotfile_options.keys.each do |variable|
      ENV.delete(variable.to_s)
    end
  end

  config.after(:each) do
    FileUtils.rm_rf(Dir.glob("#{File.dirname(__FILE__)}/support/tmp/*"))
  end
end
