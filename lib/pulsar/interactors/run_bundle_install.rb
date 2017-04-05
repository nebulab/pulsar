module Pulsar
  class RunBundleInstall
    include Pulsar::ExtendedInteractor

    validate_context_for :config_path, :bundle_path

    def call
      gemfile_env = "BUNDLE_GEMFILE=#{context.config_path}/Gemfile"
      bundle_env  = "BUNDLE_PATH=#{context.bundle_path}"
      cmd_env     = "#{gemfile_env} #{bundle_env}"
      out_redir   = ENV['DRY_RUN'] ? '> /dev/null 2>&1' : nil
      bundle_cmd  = "#{cmd_env} bundle check || #{cmd_env} bundle install"

      Bundler.with_clean_env do
        Rake.sh("#{bundle_cmd}#{out_redir}")
      end
    rescue
      context.fail!
    end
  end
end
