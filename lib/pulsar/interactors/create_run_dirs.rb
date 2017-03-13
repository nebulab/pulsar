module Pulsar
  class CreateRunDirs
    include Interactor

    def call
      context.timestamp = Time.now.to_f
      context.bundle_path = "#{PULSAR_HOME}/bundle"
      context.run_path = "#{PULSAR_TMP}/run-#{context.timestamp}"
      context.config_path = "#{context.run_path}/conf"
      context.cap_path = "#{context.run_path}/cap"

      FileUtils.mkdir_p(context.bundle_path)
      FileUtils.mkdir_p(context.config_path)
      FileUtils.mkdir_p(context.cap_path)
    end

    def rollback
      FileUtils.rm_rf(context.run_path)
    end
  end
end
