module Pulsar
  class ListCommand < UtilsCommand
    include Pulsar::Options::ConfRepo

    def execute
      with_clean_env_and_supported_vars do
        begin
          create_tmp_dir
          fetch_repo

          list_apps
        ensure
          remove_capfile unless keep_capfile?
          remove_repo unless keep_repo?
        end
      end
    end
  end
end
