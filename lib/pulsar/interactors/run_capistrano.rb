module Pulsar
  class RunCapistrano
    include Interactor

    before :validate_input!

    def call
      Dir.chdir(context.cap_path) do
        gemfile_env = "BUNDLE_GEMFILE=#{context.config_path}/Gemfile"
        bundle_env  = "BUNDLE_PATH=#{context.bundle_path}"
        cap_opts    = ENV['DRY_RUN'] ? '--dry-run ' : nil
        out_redir   = ENV['DRY_RUN'] ? '> /dev/null 2>&1' : nil
        cap_cmd     = "bundle exec cap #{cap_opts}#{context.environment} deploy"

        context_fail! errors: "Capistrano command failed!" unless system("#{gemfile_env} #{bundle_env} #{cap_cmd}#{out_redir}")
      end
    rescue
      context_fail! errors: $!.message
    end

    private

    def validate_input!
      context_fail! if context.cap_path.nil? ||
                       context.config_path.nil? ||
                       context.bundle_path.nil? ||
                       context.environment.nil?
    end
  end
end
