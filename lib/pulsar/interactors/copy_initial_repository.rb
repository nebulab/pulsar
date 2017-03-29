module Pulsar
  class CopyInitialRepository
    include Interactor

    before :validate_input!

    def call
      current_path = File.dirname(__FILE__)
      initial_repo = "#{current_path}/../generators/initial_repo"

      FileUtils.cp_r(File.expand_path(initial_repo), context.directory)
    rescue
      context_fail! errors: $!.message
    end

    private

    def validate_input!
      context_fail! if context.directory.nil?
    end
  end
end
