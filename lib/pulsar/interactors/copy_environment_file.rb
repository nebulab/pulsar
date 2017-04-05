module Pulsar
  class CopyEnvironmentFile
    include Pulsar::ExtendedInteractor

    validate_context_for :config_path, :cap_path, :application, :applications, :environment
    before :validate_input!, :prepare_context

    def call
      env_file = "#{context.config_path}/apps/#{context.application}/#{context.environment}.rb"

      FileUtils.mkdir_p(context.cap_deploy_path)
      FileUtils.cp(env_file, context.environment_file_path)
    rescue
      context.fail! error: Pulsar::ContextError.new($!.message)
    end

    private

    def prepare_context
      context.cap_deploy_path = "#{context.cap_path}/config/deploy"
      context.environment_file_path = "#{context.cap_deploy_path}/#{context.environment}.rb"
    end

    def validate_input!
      unless context.applications[context.application].include? context.environment
        context.fail! error: "The application #{context.application} does not have an environment called #{context.environment}"
      end
    end
  end
end
