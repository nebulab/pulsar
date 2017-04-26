module Pulsar
  class IdentifyRepositoryLocation
    include Interactor
    include Pulsar::Validator

    def call
      context.repository_location = if File.exist?(context.repository)
                                      :local
                                    else
                                      :remote
                                    end
    rescue
      context_fail! $!.message
    end
  end
end
