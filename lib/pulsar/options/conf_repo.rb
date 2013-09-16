module Pulsar
  module Options
    module ConfRepo
      def self.included(base)
        base.option [ "-c", "--conf-repo" ], "REPO URL",
                                             "a git repository with deploy configurations, mainly apps and recipes",
                                             :environment_variable => "PULSAR_CONF_REPO",
                                             :required => true

        base.option [ "-k", "--keep-capfile" ], :flag,
                                                "don't remove the generated capfile in the TMP DIR directory",
                                                :default => false

        base.option [ "-r", "--keep-repo" ], :flag,
                                             "don't remove the downloaded configuration repository from the TMP DIR directory",
                                             :default => false

        base.option [ "-b", "--conf-branch" ], "REPO BRANCH",
                                               "specify a branch for the configuration repository",
                                               :default => "master"

        base.option [ "-d", "--tmp-dir" ], "TMP DIR",
                                           "a directory where to put the configuration repo to build capfile with",
                                           :default => "/tmp/pulsar"
      end

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
    end
  end
end
