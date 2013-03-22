module Pulsar
  class ListCommand < UtilsCommand
    option [ "-k", "--keep-capfile" ], :flag, 
                                       "don't remove the generated capfile in the TMP DIR directory",
                                       :default => false

    option [ "-r", "--keep-repo" ], :flag,
                                    "don't remove the downloaded configuration repository from the TMP DIR directory",
                                    :default => false

    option [ "-c", "--conf-repo" ], "REPO URL",
                                    "a git repository with deploy configurations, mainly apps and recipes",
                                    :required => true

    option [ "-b", "--conf-branch" ], "REPO BRANCH",
                                      "specify a branch for the configuration repository",
                                      :default => "master"

    option [ "-d", "--tmp-dir" ], "TMP DIR",
                                  "a directory where to put the configuration repo to build capfile with",
                                  :default => "/tmp/pulsar"

    def execute
      Bundler.with_clean_env do
        fetch_repo
        
        list_apps

        remove_capfile unless keep_capfile?
        remove_repo unless keep_repo?
      end
    end
  end
end
