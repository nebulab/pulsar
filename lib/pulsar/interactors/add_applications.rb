module Pulsar
  class AddApplications
    include Interactor

    before :validate_input!, :prepare_context
    after :validate_output!

    def call
      Dir["#{context.repository}/*"].each do |app|
        stages = Dir["#{app}/*.rb"].map { |file| File.basename(file, '.rb') }

        context.applications << "#{File.basename(app)}: #{stages.join(', ')}"
      end
    rescue
      context.fail!
    end

    private

    def prepare_context
      context.applications = []
    end

    def validate_input!
      context.fail! if context.repository.nil?
    end

    def validate_output!
      context.fail! if context.applications.empty?
    end
  end
end
