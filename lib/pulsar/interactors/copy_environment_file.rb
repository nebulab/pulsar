module Pulsar
  class CopyEnvironmentFile
    include Interactor

    before :validate_input!, :prepare_context

    def call
      env_file = "#{context.config_path}/apps/#{context.application}/#{context.environment}.rb"

      FileUtils.mkdir_p(context.cap_deploy_path)
      FileUtils.cp(env_file, context.environment_file_path)
    rescue
      context.fail! error: $!.message
    end

    private

    def prepare_context
      context.cap_deploy_path = "#{context.cap_path}/config/deploy"
      context.environment_file_path = "#{context.cap_deploy_path}/#{context.environment}.rb"
    end

    def validate_input!
      context.fail! if context.config_path.nil? ||
                       context.cap_path.nil? ||
                       context.application.nil? ||
                       context.applications.nil? ||
                       context.environment.nil?
      unless context.applications[context.application].include? context.environment
        context.fail! error: "The application #{context.application} does not have an environment called #{context.environment}"
      end
    end
  end
end
