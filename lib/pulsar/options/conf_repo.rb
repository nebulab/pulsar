module Pulsar
  module Options
    module ConfRepo
      def self.included(base)
        base.option [ "-k", "--keep-capfile" ], :flag, 
                                                "don't remove the generated capfile in the TMP DIR directory",
                                                :default => false

        base.option [ "-r", "--keep-repo" ], :flag,
                                             "don't remove the downloaded configuration repository from the TMP DIR directory",
                                             :default => false

        base.option [ "-c", "--conf-repo" ], "REPO URL",
                                             "a git repository with deploy configurations, mainly apps and recipes",
                                             :required => true

        base.option [ "-b", "--conf-branch" ], "REPO BRANCH",
                                               "specify a branch for the configuration repository",
                                               :default => "master"

        base.option [ "-d", "--tmp-dir" ], "TMP DIR",
                                           "a directory where to put the configuration repo to build capfile with",
                                           :default => "/tmp/pulsar"
      end
    end
  end
end
