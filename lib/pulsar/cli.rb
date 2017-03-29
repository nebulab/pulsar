module Pulsar
  class CLI < Thor
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
      else
        puts 'Failed to create intial repo.'
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
        puts result.applications
      else
        puts 'Failed to list application and environments.'
        puts result.errors
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
      result = Pulsar::Deploy.call(
        repository: load_option_or_env!(:conf_repo),
        application: application, environment: environment
      )

      if result.success?
        puts "Deployed #{application} on #{environment}!"
      else
        puts "Failed to deploy #{application} on #{environment}."
      end
    end

    desc "--version, -v", "print the version"
    def __print_version
      puts Pulsar::VERSION
    end

    private

    def load_config
      Dotenv.load(PULSAR_CONF) # Load configurations for Pulsar
    end

    def load_option_or_env!(option)
      option_name    = "--#{option.to_s.tr!('_', '-')}"
      env_option     = "PULSAR_#{option.upcase}"
      exception_text = "No value provided for required options '#{option_name}'"
      option_value   = options[option] || ENV[env_option]

      if option_value.nil? || option_value.empty?
        fail RequiredArgumentMissingError,
             exception_text
      end

      option_value
    end
  end
end
