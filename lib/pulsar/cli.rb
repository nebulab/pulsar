if ENV['COVERAGE']
  ENV['FEATURE_TESTS'] = 'true'
  require_relative '../../spec/support/coverage_setup'
end

module Pulsar
  class CLI < Thor
    def self.exit_on_failure?; true; end

    map %w[--version -v] => :__print_version

    desc 'install [DIRECTORY]', 'Install initial repository in DIRECTORY'
    long_desc <<-LONGDESC
      `pulsar install` will install the initial pulsar repository in the
      current working directory.

      You can optionally specify a second parameter, which will be the
      destination directory in which to install the repository.
    LONGDESC
    def install(directory = './pulsar-conf')
      result = Pulsar::Install.call(directory: directory)

      if result.success?
        puts 'Successfully created intial repo!'
        exit_with_status 0
      else
        puts 'Failed to create intial repo.'
        puts result.error
        exit_with_status result.error.is_a?(Pulsar::ContextError) ? result.error.exit_code : 1
      end
    end

    desc 'list', 'List available applications and environments'
    long_desc <<-LONGDESC
      `pulsar list` will list the applications and environments available in
      the configured pulsar repository.
    LONGDESC
    option :conf_repo, aliases: '-c'
    def list
      load_config
      result = Pulsar::List.call(repository: load_option_or_env!(:conf_repo))

      if result.success?
        result.applications.each do |app, stages|
          puts "#{app}: #{stages.join(', ')}"
        end
        exit_with_status 0
      else
        puts 'Failed to list application and environments.'
        puts result.error
        exit_with_status result.error.is_a?(Pulsar::ContextError) ? result.error.exit_code : 1
      end
    end

    desc 'deploy APPLICATION ENVIRONMENT', 'Run Capistrano to deploy APPLICATION on ENVIRONMENT'
    long_desc <<-LONGDESC
      `pulsar deploy APPLICATION ENVIRONMENT` will generate the configuration for the
      specified APPLICATION on ENVIRONMENT from the configuration repo and run
      Capistrano on it.
    LONGDESC
    option :conf_repo, aliases: '-c'
    def deploy(application, environment)
      load_config
      result = Pulsar::Task.call(
        repository: load_option_or_env!(:conf_repo),
        application: application, environment: environment,
        task: 'deploy'
      )

      if result.success?
        puts "Deployed #{application} on #{environment}!"
        exit_with_status 0
      else
        puts "Failed to deploy #{application} on #{environment}."
        puts result.error
        exit_with_status result.error.is_a?(Pulsar::ContextError) ? result.error.exit_code : 1
      end
    end

    desc 'task APPLICATION ENVIRONMENT TASK', 'Run Capistrano task for APPLICATION on ENVIRONMENT'
    option :conf_repo, aliases: '-c'
    def task(application, environment, task)
      load_config
      result = Pulsar::Task.call(
        repository: load_option_or_env!(:conf_repo),
        application: application, environment: environment,
        task: task
      )

      if result.success?
        puts "Executed task #{task} for #{application} on #{environment}!"
      else
        puts "Failed to execute task #{task} for #{application} on #{environment}."
        puts result.error
      end
    end

    desc "--version, -v", "print the version"
    def __print_version
      puts Pulsar::VERSION
      exit_with_status 0
    end

    private

    def exit_with_status(status)
      exit status
    end

    def load_config
      return unless File.exist?(PULSAR_CONF) && File.stat(PULSAR_CONF).readable?

      Dotenv.load(PULSAR_CONF) # Load configurations for Pulsar
    end

    def load_option_or_env!(option)
      option_name    = "--#{option.to_s.tr!('_', '-')}"
      env_option     = "PULSAR_#{option.upcase}"
      exception_text = "No value provided for required options '#{option_name}'"
      option_value   = options[option] || ENV[env_option]

      if option_value.nil? || option_value.empty?
        fail RequiredArgumentMissingError, exception_text
      end

      option_value
    end
  end
end
