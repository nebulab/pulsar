module Pulsar
  class RunCapistrano
    include Interactor

    before :validate_input!

    def call
      Dir.chdir(context.cap_path) do
        gemfile_env = "BUNDLE_GEMFILE=#{context.config_path}/Gemfile"
        bundle_env  = "BUNDLE_PATH=#{context.bundle_path}"

        system("#{gemfile_env} #{bundle_env} bundle exec cap #{'--dry-run ' if ENV['CAP_DRY_RUN']}#{context.environment} deploy")
      end
    rescue
      context.fail!
    end

    private

    def validate_input!
      context.fail! if context.cap_path.nil? ||
                       context.config_path.nil? ||
                       context.bundle_path.nil? ||
                       context.environment.nil?
    end
  end
end
