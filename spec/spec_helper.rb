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
end
