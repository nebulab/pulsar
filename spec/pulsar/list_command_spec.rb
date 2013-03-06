require 'spec_helper'

describe Pulsar::ListCommand do
  let(:pulsar) { Pulsar::ListCommand.new("list") }

  context "--conf-repo option" do
    it "is required" do
      expect { pulsar.parse([""]) }.to raise_error(Clamp::UsageError)
    end
    
    it "supports directories" do
      expect { pulsar.run(base_args + %w(--tmp-dir dummy_tmp) + dummy_app) }.not_to raise_error(Errno::ENOENT)
    end
  end

  context "--tmp-dir option" do
    it "is supported" do
      expect { pulsar.parse(base_args + %w(--tmp-dir dummy_tmp)) }.to_not raise_error(Clamp::UsageError)
    end
  end

  context "--keep-capfile option" do
    it "is supported" do
      expect { pulsar.parse(base_args + %w(--keep-capfile)) }.to_not raise_error(Clamp::UsageError)
    end
  end
end
