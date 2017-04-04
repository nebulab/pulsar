module Pulsar
  class IdentifyRepositoryType
    include Interactor

    before :validate_input!

    def call
      case context.repository_location
      when :local
        context.repository_type = :folder
      when :remote
        context.repository_type = github_repository? ? :github : :git
      end
    rescue
      context.fail! error: $!.message
    end

    private

    def validate_input!
      context.fail! if context.repository.nil?
      context.fail! if context.repository_location.nil?
    end

    def github_repository?
      context.repository =~ %r{^[\w-]+\/[\w-]+$}
    end
  end
end
