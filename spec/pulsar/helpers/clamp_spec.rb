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

  context "run_capistrano" do
    before do
      self.stub!(:config_path).and_return(dummy_conf_path)
      self.stub!(:verbose?).and_return(false)
      self.stub!(:capfile_path).and_return('/stubbed/capfile')
    end

    it "runs capistrano when pulsar is invoked from outside the application directory" do
      self.should_receive(:run_cmd).with("bundle exec cap CONFIG_PATH=#{config_path} --file #{capfile_path} deploy", anything)

      run_capistrano("deploy")
    end

    it "runs capistrano when pulsar is invoked from inside the application directory" do
      self.stub!(:application_path).and_return("/app/path")

      self.should_receive(:run_cmd).with("bundle exec cap CONFIG_PATH=#{config_path} APP_PATH=#{application_path} --file #{capfile_path} deploy", anything)

      run_capistrano("deploy")
    end
  end
end
