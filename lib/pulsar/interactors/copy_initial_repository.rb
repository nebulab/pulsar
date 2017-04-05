module Pulsar
  class CopyInitialRepository
    include Pulsar::ExtendedInteractor

    validate_context_for :directory

    def call
      current_path = File.dirname(__FILE__)
      initial_repo = "#{current_path}/../generators/initial_repo"

      FileUtils.cp_r(File.expand_path(initial_repo), context.directory)
    rescue
      context.fail! error: Pulsar::ContextError.new($!.message)
    end
  end
end
