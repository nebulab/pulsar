require 'spec_helper'

describe Pulsar::Helpers::Clamp do
  include Pulsar::Helpers::Clamp

  context "fetch_repo" do
    it "supports directories" do
      allow(File).to receive(:directory?).and_return(true)
      allow(self).to receive(:conf_repo).and_return("conf-repo/path")
      allow(self).to receive(:fetch_directory_repo)

      fetch_repo

      expect(self).to have_received(:fetch_directory_repo).with("conf-repo/path")
    end

    it "supports full git path" do
      allow(File).to receive(:directory?).and_return(false)
      allow(self).to receive(:conf_repo).and_return("git://github.com/gh_user/pulsar-conf.git")
      allow(self).to receive(:fetch_git_repo)

      fetch_repo

      expect(self).to have_received(:fetch_git_repo).with("git://github.com/gh_user/pulsar-conf.git")
    end

    it "supports full git path on ssh" do
      allow(File).to receive(:directory?).and_return(false)
      allow(self).to receive(:conf_repo).and_return("git@github.com:gh_user/pulsar-conf.git")
      allow(self).to receive(:fetch_git_repo)

      fetch_repo

      expect(self).to have_received(:fetch_git_repo).with("git@github.com:gh_user/pulsar-conf.git")
    end

    it "supports full git path on http" do
      allow(File).to receive(:directory?).and_return(false)
      allow(self).to receive(:conf_repo).and_return("https://github.com/gh_user/pulsar.git")
      allow(self).to receive(:fetch_git_repo)

      fetch_repo

      expect(self).to have_received(:fetch_git_repo).with("https://github.com/gh_user/pulsar.git")
    end

    it "supports github path" do
      allow(File).to receive(:directory?).and_return(false)
      allow(self).to receive(:conf_repo).and_return("gh-user/pulsar-conf")
      allow(self).to receive(:fetch_git_repo)

      fetch_repo

      expect(self).to have_received(:fetch_git_repo).with("git@github.com:gh-user/pulsar-conf.git")
    end
  end

  context "run_capistrano" do
    before do
      allow(self).to receive(:config_path).and_return(dummy_conf_path)
      allow(self).to receive(:verbose?).and_return(false)
      allow(self).to receive(:capfile_path).and_return('/stubbed/capfile')
      allow(self).to receive(:run_cmd)
    end

    it "runs capistrano when pulsar is invoked from outside the application directory" do
      run_capistrano("deploy")

      expect(self).to have_received(:run_cmd).with("bundle exec cap CONFIG_PATH=#{config_path} --file #{capfile_path} deploy", anything)
    end

    it "runs capistrano when pulsar is invoked from inside the application directory" do
      allow(self).to receive(:application_path).and_return("/app/path")

      run_capistrano("deploy")

      expect(self).to have_received(:run_cmd).with("bundle exec cap CONFIG_PATH=#{config_path} APP_PATH=#{application_path} --file #{capfile_path} deploy", anything)
    end
  end
end
