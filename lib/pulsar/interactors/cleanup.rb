module Pulsar
  class Cleanup
    include Interactor

    def call
      FileUtils.rm_rf(context.config_path)
    end
  end
end
