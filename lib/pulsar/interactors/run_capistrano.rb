module Pulsar
  class RunCapistrano
    include Interactor
    include Pulsar::Validator

    def call
      Dir.chdir(context.cap_path) do
        gemfile_env = "BUNDLE_GEMFILE=#{context.config_path}/Gemfile"
        bundle_env  = "BUNDLE_PATH=#{context.bundle_path}"
        cap_opts    = ENV['DRY_RUN'] ? '--dry-run ' : nil
        out_redir   = ENV['DRY_RUN'] ? '> /dev/null 2>&1' : nil
        cap_cmd     = "bundle exec cap #{cap_opts}#{context.environment} deploy"

        Rake.sh("#{gemfile_env} #{bundle_env} #{cap_cmd}#{out_redir}")
      end
    rescue
      context.fail! error: Pulsar::ContextError.new($!.message)
    end

    private

    def validate_context_for!
      validate_context_for! :cap_path, :config_path, :bundle_path, :environment
    end
  end
end
