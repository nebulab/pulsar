module Pulsar
  class RunBundleInstall
    include Interactor

    before :validate_input!

    def call
      gemfile_env = "BUNDLE_GEMFILE=#{context.config_path}/Gemfile"
      bundle_env  = "BUNDLE_PATH=#{context.bundle_path}"

      system("#{gemfile_env} #{bundle_env} bundle install")
    rescue
      context.fail!
    end

    private

    def validate_input!
      context.fail! if context.config_path.nil? ||
                       context.bundle_path.nil?
    end
  end
end
