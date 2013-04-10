require 'spec_helper'

describe Pulsar::Helpers::Clamp do
  include Pulsar::Helpers::Clamp

  context "run_cmd" do
    it "raises exception if command fails" do
      expect { run_cmd("return 1", {}) }.to raise_error
    end
  end

  context "reset_for_other_app!" do
    it "resets instance variables written by the module" do
      cap, conf, time = capfile_path, config_path, time_to_deploy

      reset_for_other_app!

      capfile_path.should_not == cap
      config_path.should_not == conf
      time_to_deploy.should_not == time
    end
  end
end
