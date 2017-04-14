module Pulsar
  class CreateCapfile
    include Pulsar::ExtendedInteractor

    validate_context_for :config_path, :cap_path, :application; :applications
    before :validate_input!, :prepare_context

    def call
      default_capfile = "#{context.config_path}/apps/Capfile"
      app_capfile     = "#{context.config_path}/apps/#{context.application}/Capfile"
      import_tasks    = "Dir.glob(\"#{context.config_path}/recipes/**/*.rake\").each { |r| import r }"

      FileUtils.touch(context.capfile_path)
      Rake.sh("cat #{default_capfile} >> #{context.capfile_path}") if File.exist?(default_capfile)
      Rake.sh("cat #{app_capfile}     >> #{context.capfile_path}") if File.exist?(app_capfile)
      Rake.sh("echo '#{import_tasks}' >> #{context.capfile_path}")
    rescue
      context.fail! error: Pulsar::ContextError.new($!.message)
    end

    private

    def prepare_context
      context.capfile_path = "#{context.cap_path}/Capfile"
    end

    def validate_input!
      context.fail! if context.config_path.nil? ||
                       context.cap_path.nil? ||
                       context.application.nil?

      fail_on_missing_application! unless application_exists?
    end

    def application_exists?
      context.applications.keys.include? context.application
    end

    def fail_on_missing_application!
      context.fail! error: "The application #{context.application} does not exist in your repository"
    end
  end
end
