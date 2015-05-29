module Pulsar
  class Install
    include Interactor

    before do
      context.fail! if context.directory.nil?
    end

    def call
      current_path = File.dirname(__FILE__)
      initial_repo = "#{current_path}/../generators/initial_repo"

      FileUtils.cp_r(File.expand_path(initial_repo), context.directory)
    rescue
      context.fail!
    end
  end
end
