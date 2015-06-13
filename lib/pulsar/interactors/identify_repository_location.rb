module Pulsar
  class IdentifyRepositoryLocation
    include Interactor

    before :validate_input!

    def call
      if File.exist?(context.repository)
        context.repository_location = :local
      else
        context.repository_location = :remote
      end
    rescue
      context.fail!
    end

    private

    def validate_input!
      context.fail! if context.repository.nil?
    end
  end
end
