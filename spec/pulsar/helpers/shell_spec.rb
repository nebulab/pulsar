require 'spec_helper'

describe Pulsar::Helpers::Shell do
  include Pulsar::Helpers::Shell

  context "run_cmd" do
    it "raises exception if command fails" do
      expect{ run_cmd("false", {}) }.to raise_error
    end
  end
end
