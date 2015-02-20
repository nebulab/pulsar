require 'spec_helper'

describe Pulsar::Helpers::Clamp do
  include Pulsar::Helpers::Clamp

  context 'fetch_repo' do
    it 'supports directories' do
      allow(File).to receive(:directory?).and_return(true)
      allow(self).to receive(:conf_repo).and_return('conf-repo/path')
      allow(self).to receive(:fetch_directory_repo)

      fetch_repo

      expect(self)
        .to have_received(:fetch_directory_repo).with('conf-repo/path')
    end

    it 'supports full git path' do
      allow(File).to receive(:directory?).and_return(false)
      allow(self).to receive(:fetch_git_repo)
      allow(self)
        .to receive(:conf_repo)
        .and_return('git://github.com/gh_user/pulsar-conf.git')

      fetch_repo

      expect(self)
        .to have_received(:fetch_git_repo)
        .with('git://github.com/gh_user/pulsar-conf.git')
    end

    it 'supports full git path on ssh' do
      allow(File).to receive(:directory?).and_return(false)
      allow(self).to receive(:fetch_git_repo)
      allow(self)
        .to receive(:conf_repo)
        .and_return('git@github.com:gh_user/pulsar-conf.git')

      fetch_repo

      expect(self)
        .to have_received(:fetch_git_repo)
        .with('git@github.com:gh_user/pulsar-conf.git')
    end

    it 'supports full git path on http' do
      allow(File).to receive(:directory?).and_return(false)
      allow(self).to receive(:fetch_git_repo)
      allow(self)
        .to receive(:conf_repo)
        .and_return('https://github.com/gh_user/pulsar.git')

      fetch_repo

      expect(self)
        .to have_received(:fetch_git_repo)
        .with('https://github.com/gh_user/pulsar.git')
    end

    it 'supports github path' do
      allow(File).to receive(:directory?).and_return(false)
      allow(self).to receive(:conf_repo).and_return('gh-user/pulsar-conf')
      allow(self).to receive(:fetch_git_repo)

      fetch_repo

      expect(self)
        .to have_received(:fetch_git_repo)
        .with('git@github.com:gh-user/pulsar-conf.git')
    end
  end

  context 'run_capistrano' do
    before do
      allow(self).to receive(:config_path).and_return(dummy_conf_path)
      allow(self).to receive(:verbose?).and_return(false)
      allow(self).to receive(:capfile_path).and_return('/stubbed/capfile')
      allow(self).to receive(:run_cmd)
    end

    it 'runs capistrano when pulsar is invoked from outside an application' do
      cap_cmd    = 'bundle exec cap'
      env_vars   = "CONFIG_PATH=#{config_path}"
      cmd_args   = "--file #{capfile_path} deploy"
      full_cmd   = "#{cap_cmd} #{env_vars} #{cmd_args}"

      run_capistrano('deploy')

      expect(self).to have_received(:run_cmd).with(full_cmd, anything)
    end

    it 'runs capistrano when pulsar is invoked from inside an application' do
      allow(self).to receive(:application_path).and_return('/app/path')

      cap_cmd    = 'bundle exec cap'
      env_vars   = "CONFIG_PATH=#{config_path} APP_PATH=#{application_path}"
      cmd_args   = "--file #{capfile_path} deploy"
      full_cmd   = "#{cap_cmd} #{env_vars} #{cmd_args}"

      run_capistrano('deploy')

      expect(self).to have_received(:run_cmd).with(full_cmd, anything)
    end
  end
end
