module Pulsar
  class AddApplications
    include Interactor

    before :validate_input!, :prepare_context
    after :validate_output!

    def call
      each_application_path do |app|
        context.applications << "#{File.basename(app)}: #{stages_for(app)}"
      end
    rescue
      context.fail!
    end

    private

    def prepare_context
      context.applications = []
    end

    def validate_input!
      context.fail! if context.config_path.nil?
    end

    def validate_output!
      context.fail! if context.applications.empty?
    end

    def each_application_path
      Dir["#{context.config_path}/apps/*"].each { |app| yield(app) }
    end

    def stages_for(app)
      stage_files = Dir["#{app}/*.rb"].map { |file| File.basename(file, '.rb') }

      stage_files.reject { |stage| stage == 'defaults' }.join(', ')
    end
  end
end
