module Pulsar
  class IdentifyRepositoryType
    include Interactor

    before :validate_input!

    def call
      case context.repository_location
      when :local
        context.repository_type = git_repository? ? :git : :folder
      when :remote
        context.repository_type = github_repository? ? :github : :git
      end
    rescue
      context_fail! errors: $!.message
    end

    private

    def validate_input!
      context_fail! if context.repository.nil?
      context_fail! if context.repository_location.nil?
    end

    def git_repository?
      git_status = "git -C #{context.repository} status >/dev/null 2>&1"

      Rake.sh(git_status) { |status, _| status }
    end

    def github_repository?
      context.repository =~ %r{^[\w-]+\/[\w-]+$}
    end
  end
end
