module Pulsar
  class IdentifyRepositoryType
    include Interactor
    include Pulsar::Validator

    validate_context_for! :repository, :repository_location

    def call
      case context.repository_location
      when :local
        context.repository_type = :folder
      when :remote
        context.repository_type = github_repository? ? :github : :git
      end
    end

    private

    def github_repository?
      context.repository =~ %r{^[\w-]+\/[\w-]+$}
    end
  end
end
