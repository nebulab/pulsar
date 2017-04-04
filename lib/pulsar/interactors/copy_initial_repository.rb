module Pulsar
  class CopyInitialRepository
    include Interactor

    before :validate_input!

    def call
      current_path = File.dirname(__FILE__)
      initial_repo = "#{current_path}/../generators/initial_repo"

      FileUtils.cp_r(File.expand_path(initial_repo), context.directory)
    rescue
      context.fail! error: $!.message
    end

    private

    def validate_input!
      context.fail! if context.directory.nil?
    end
  end
end
