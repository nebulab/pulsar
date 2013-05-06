require 'spec_helper'

describe Pulsar::Helpers::Shell do
  include Pulsar::Helpers::Shell

  context "run_cmd" do
    it "raises exception if command fails" do
      expect { run_cmd("return 1", {}) }.to raise_error
    end
  end
end
