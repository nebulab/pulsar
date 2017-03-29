module Pulsar
  class CopyEnvironmentFile
    include Interactor

    before :validate_input!, :prepare_context

    def call
      env_file = "#{context.config_path}/apps/#{context.application}/#{context.environment}.rb"

      FileUtils.mkdir_p(context.cap_deploy_path)
      FileUtils.cp(env_file, context.environment_file_path)
    rescue
      context_fail! errors: $!.message
    end

    private

    def prepare_context
      context.cap_deploy_path = "#{context.cap_path}/config/deploy"
      context.environment_file_path = "#{context.cap_deploy_path}/#{context.environment}.rb"
    end

    def validate_input!
      context_fail! if context.config_path.nil? ||
                       context.cap_path.nil? ||
                       context.application.nil? ||
                       context.environment.nil?
    end
  end
end
