module Pulsar
  class ListCommand < MainCommand
    option [ "-k", "--keep-capfile" ], :flag, 
                                       "don't remove the generated capfile in the /tmp/ directory",
                                       :default => false

    option [ "-c", "--conf-repo" ], "REPO URL",
                                    "a git repository with deploy configurations, mainly apps and recipes",
                                    :required => true

    option [ "-b", "--conf-branch" ], "REPO BRANCH",
                                      "specify a branch for the configuration repository",
                                      :default => "master"

    def execute
      Bundler.with_clean_env do
        fetch_repo
        
        list_apps

        remove_capfile unless keep_capfile?
        remove_repo
      end
    end
  end
end
