module Pulsar
  class ListCommand < UtilsCommand
    include Pulsar::Options::ConfRepo

    def execute
      Bundler.with_clean_env do
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
