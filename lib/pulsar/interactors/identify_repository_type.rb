module Pulsar
  class IdentifyRepositoryType
    include Interactor

    before :validate_input!

    def call
      if Rake.sh("git -C #{context.repository} status") &&
         File.exist?("#{context.repository}/.git")
        context.repository_type = :local_git
      else
        context.repository_type = :local_folder
      end
    rescue
      context.fail!
    end

    private

    def validate_input!
      context.fail! if context.repository.nil?
      context.fail! unless File.exist?(context.repository)
    end
  end
end
