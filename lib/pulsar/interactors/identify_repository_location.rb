module Pulsar
  class IdentifyRepositoryLocation
    include Interactor

    before :validate_input!

    def call
      context.repository_location = if File.exist?(context.repository)
                                      :local
                                    else
                                      :remote
                                    end
    rescue
      context.fail! error: Pulsar::ContextError.new($!.message)
    end

    private

    def validate_input!
      context.fail! if context.repository.nil?
    end
  end
end
