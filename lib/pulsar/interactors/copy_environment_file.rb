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
      context.fail! if context.config_path.nil? ||
                       context.cap_path.nil? ||
                       context.application.nil? ||
                       context.applications.nil? ||
                       context.environment.nil?

      fail_on_missing_environment! unless environment_exist?
    end

    def environment_exist?
      context.applications[context.application].include?(context.environment)
    end

    def fail_on_missing_environment!
      context.fail! error: Pulsar::ContextError.new("The application #{context.application} does not have an environment called #{context.environment}")
    end
  end
end
