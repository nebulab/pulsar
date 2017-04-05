module Pulsar
  class Cleanup
    include Pulsar::ExtendedInteractor

    def call
      FileUtils.rm_rf(context.run_path)
    end
  end
end
