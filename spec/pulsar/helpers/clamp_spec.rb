require 'spec_helper'

describe Pulsar::Helpers::Clamp do
  include Pulsar::Helpers::Clamp

  context "run_cmd" do
    it "raises exception if command fails" do
      expect { run_cmd("return 1", {}) }.to raise_error
    end
  end
end
