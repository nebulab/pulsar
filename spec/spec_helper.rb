require "rspec"
require "stringio"
require "fileutils"
require "pulsar"
require "pulsar/commands/main"

#
# Require all helper modules
# 
Dir[File.join(File.dirname(__FILE__), 'support/modules/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rr

  config.include Helpers
  config.include OutputCapture

  config.after(:suite) do
    FileUtils.rm_r(Dir.glob("#{File.dirname(__FILE__)}/support/tmp/*"))
  end
end
