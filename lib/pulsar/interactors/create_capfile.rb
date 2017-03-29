module Pulsar
  class CreateCapfile
    include Interactor

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
      context_fail! errors: $!.message
    end

    private

    def prepare_context
      context.capfile_path = "#{context.cap_path}/Capfile"
    end

    def validate_input!
      context_fail! if context.config_path.nil? ||
                       context.cap_path.nil? ||
                       context.application.nil?
    end
  end
end
