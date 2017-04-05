module Pulsar
  class IdentifyRepositoryLocation
    include Pulsar::ExtendedInteractor

    validate_context_for :repository

    def call
      context.repository_location = if File.exist?(context.repository)
                                      :local
                                    else
                                      :remote
                                    end
    rescue
      context.fail! error: Pulsar::ContextError.new($!.message)
    end
  end
end
