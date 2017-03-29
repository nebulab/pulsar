module Pulsar
  class RunBundleInstall
    include Interactor

    before :validate_input!

    def call
      gemfile_env = "BUNDLE_GEMFILE=#{context.config_path}/Gemfile"
      bundle_env  = "BUNDLE_PATH=#{context.bundle_path}"
      cmd_env     = "#{gemfile_env} #{bundle_env}"
      out_redir   = ENV['DRY_RUN'] ? '> /dev/null 2>&1' : nil
      bundle_cmd  = "#{cmd_env} bundle check || #{cmd_env} bundle install"

      Bundler.with_clean_env do
        context_fail! unless system("#{bundle_cmd}#{out_redir}")
      end
    rescue
      context_fail! errors: $!.message
    end

    private

    def validate_input!
      context_fail! if context.config_path.nil? ||
                       context.bundle_path.nil?
    end
  end
end
