module Pulsar
  class ListCommand < UtilsCommand
    include Pulsar::Options::ConfRepo

    #
    # TODO: find a way to fix this hack. This is made so that
    # load_configuration() is called before Clamp parses command
    # line arguments (and runs into errors because no conf repo
    # is defined).
    #
    def parse(arguments)
      self.class.send(:include, Pulsar::Helpers::Clamp)
      load_configuration
      super
    end

    def execute
      Bundler.with_clean_env do
        begin
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
