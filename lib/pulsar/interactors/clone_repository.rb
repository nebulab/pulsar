module Pulsar
  class CloneRepository
    include Interactor

    before :validate_input!, :prepare_context

    def call
      case context.repository_type
      when :local_git    then prepare_local_git
      when :local_folder then prepare_local_folder
      end
    rescue
      context.fail!
    end

    private

    def prepare_context
      FileUtils.mkdir_p(PULSAR_TMP)
      context.config_path = "#{PULSAR_TMP}/conf-#{Time.now.to_f}"
    end

    def validate_input!
      context.fail! if context.repository.nil? || context.repository_type.nil?
    end

    def prepare_local_git
      Rake.sh("git clone #{context.repository} #{context.config_path}")
      FileUtils.cp_r(context.repository, context.config_path)
    end

    def prepare_local_folder
      FileUtils.cp_r(context.repository, context.config_path)
    end
  end
end
