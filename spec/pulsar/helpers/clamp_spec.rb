require 'spec_helper'

describe Pulsar::Helpers::Clamp do
  include Pulsar::Helpers::Clamp

  context "fetch_repo" do
    it "supports directories" do
      File.stub(:directory?).and_return(true)
      self.stub!(:conf_repo).and_return("conf-repo/path")

      self.should_receive(:fetch_directory_repo).with("conf-repo/path")

      fetch_repo
    end

    it "supports full git path" do
      File.stub(:directory?).and_return(false)
      self.stub!(:conf_repo).and_return("git://github.com/gh_user/pulsar-conf.git")

      self.should_receive(:fetch_git_repo).with("git://github.com/gh_user/pulsar-conf.git")

      fetch_repo
    end

    it "supports full git path on ssh" do
      File.stub(:directory?).and_return(false)
      self.stub!(:conf_repo).and_return("git@github.com:gh_user/pulsar-conf.git")

      self.should_receive(:fetch_git_repo).with("git@github.com:gh_user/pulsar-conf.git")

      fetch_repo
    end

    it "supports full git path on http" do
      File.stub(:directory?).and_return(false)
      self.stub!(:conf_repo).and_return("https://github.com/gh_user/pulsar.git")

      self.should_receive(:fetch_git_repo).with("https://github.com/gh_user/pulsar.git")

      fetch_repo
    end

    it "supports github path" do
      File.stub(:directory?).and_return(false)
      self.stub!(:conf_repo).and_return("gh-user/pulsar-conf")

      self.should_receive(:fetch_git_repo).with("git@github.com:gh-user/pulsar-conf.git")

      fetch_repo
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
