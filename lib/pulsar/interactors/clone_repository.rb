module Pulsar
  class CloneRepository
    include Interactor
    include Pulsar::Validator

    def call
      case context.repository_type
      when :git    then clone_git_repository
      when :github then clone_github_repository
      when :folder then copy_local_folder
      end
    rescue
      context.fail! error: Pulsar::ContextError.new($!.message)
    end

    private

    def validate_context!
      validate_context_for! :config_path, :repository, :repository_type
    end

    def clone_git_repository
      cmd   = 'git clone'
      opts  = '--quiet --depth 1'
      quiet = '>/dev/null 2>&1'

      Rake.sh(
        "#{cmd} #{opts} #{context.repository} #{context.config_path} #{quiet}"
      )
    end

    def clone_github_repository
      cmd   = 'git clone'
      opts  = '--quiet --depth 1'
      quiet = '>/dev/null 2>&1'
      repo  = "git@github.com:#{context.repository}.git"

      Rake.sh(
        "#{cmd} #{opts} #{repo} #{context.config_path} #{quiet}"
      )
    end

    def copy_local_folder
      raise "No repository found at #{context.repository}" unless File.exist? context.repository
      FileUtils.cp_r("#{context.repository}/.", context.config_path)
    end
  end
end
