module Pulsar
  class List
    include Interactor
    
    before do
      context.applications = []
    end

    def call
      context.fail! if context.repository.nil?
      
      Dir["#{context.repository}/*"].each do |app|
        stages = Dir["#{app}/*.rb"].map { |file| File.basename(file, '.rb') }

        context.applications << "#{File.basename(app)}: #{stages.join(', ')}"
      end
      
      context.fail! if context.applications.empty?
    rescue
      context.fail!
    end
  end
end
