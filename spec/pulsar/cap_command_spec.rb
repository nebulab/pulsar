require 'spec_helper'

describe Pulsar::CapCommand do
  include Helpers
  include OutputCapture

  let(:pulsar) { Pulsar::CapCommand.new("cap") }

  context "--conf-repo option" do
    it "is required" do
      expect { pulsar.parse([""]) }.to raise_error(Clamp::UsageError)
    end
  end

  context "--tmp-dir option" do
    it "is supported" do
      expect { pulsar.parse(base_args + %w(--tmp-dir dummy_tmp) + dummy_app) }.to_not raise_error(Clamp::UsageError)
    end
  end

  context "--keep-capfile option" do
    it "is supported" do
      expect { pulsar.parse(base_args + %w(--keep-capfile) + dummy_app) }.to_not raise_error(Clamp::UsageError)
    end
  end
end
