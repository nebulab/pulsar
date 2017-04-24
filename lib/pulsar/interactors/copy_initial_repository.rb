module Pulsar
  class CopyInitialRepository
    include Interactor
    include Pulsar::Validator

    def call
      current_path = File.dirname(__FILE__)
      initial_repo = "#{current_path}/../generators/initial_repo"

      FileUtils.cp_r(File.expand_path(initial_repo), context.directory)
    rescue
      context.fail! error: Pulsar::ContextError.new($!.message)
    end
  end
end
