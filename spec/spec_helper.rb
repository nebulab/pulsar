require "rspec"
require "stringio"
require "pulsar"

RSpec.configure do |config|
  config.mock_with :rr
end

module Helpers
  def base_args
    [ "--conf-repo", dummy_conf_path ] + dummy_app
  end

  def full_args
    [ "--conf-repo", dummy_conf_path, "--tmp-dir", tmp_path ] + dummy_app
  end

  def dummy_conf_path
    "#{File.dirname(__FILE__)}/spec/support/dummy_conf"
  end

  def tmp_path
    "#{File.dirname(__FILE__)}/spec/support/tmp"
  end

  def dummy_app
    [ "dummy_app", "production" ]
  end
end

module OutputCapture
  def self.included(target)
    target.before do
      $stdout = @out = StringIO.new
      $stderr = @err = StringIO.new
    end

    target.after do
      $stdout = STDOUT
      $stderr = STDERR
    end
  end

  def stdout
    @out.string
  end

  def stderr
    @err.string
  end
end
