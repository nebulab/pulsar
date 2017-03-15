module Pulsar
  class Cleanup
    include Interactor

    def call
      FileUtils.rm_rf(context.run_path)
    end
  end
end
