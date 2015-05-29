module Pulsar
  class Install
    include Interactor

    def call
      context.fail! if context.directory.nil?

      current_path = File.dirname(__FILE__)
      initial_repo = "#{current_path}/../generators/initial_repo"

      FileUtils.cp_r(File.expand_path(initial_repo), context.directory)
    rescue
      context.fail!
    end
  end
end
