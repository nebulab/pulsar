module Pulsar
  class Cleanup
    include Interactor
    include Pulsar::Validator

    def call
      FileUtils.rm_rf(context.run_path)
    end
  end
end
