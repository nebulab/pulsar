module Pulsar
  class CopyEnvironmentFile
    include Interactor
    include Pulsar::Validator

    validate_context_for! :config_path, :cap_path, :application, :applications
    before :validate_environment!
    before :prepare_context

    def call
      env_file = "#{context.config_path}/apps/#{context.application}/#{context.environment}.rb"

      FileUtils.mkdir_p(context.cap_deploy_path)
      FileUtils.cp(env_file, context.environment_file_path)
    rescue
      context_fail! $!.message
    end

    private

    def prepare_context
      context.cap_deploy_path = "#{context.cap_path}/config/deploy"
      context.environment_file_path = "#{context.cap_deploy_path}/#{context.environment}.rb"
    end

    def validate_environment!
      fail_on_missing_environment! unless environment_exist?
    end

    def environment_exist?
      context.applications[context.application].include?(context.environment)
    end

    def fail_on_missing_environment!
      context_fail! "The application #{context.application} does not have an environment called #{context.environment}"
    end
  end
end
