module Pulsar
  class AddApplications
    include Interactor

    around do |interactor|
      context.applications = []

      context.fail! if context.repository.nil?
      interactor.call
      context.fail! if context.applications.empty?
    end

    def call
      Dir["#{context.repository}/*"].each do |app|
        stages = Dir["#{app}/*.rb"].map { |file| File.basename(file, '.rb') }

        context.applications << "#{File.basename(app)}: #{stages.join(', ')}"
      end
    rescue
      context.fail!
    end
  end
end
