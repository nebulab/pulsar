module Pulsar
  class CapCommand < MainCommand
    option [ "-k", "--keep-capfile" ], :flag,
                                       "don't remove the generated capfile in the TMP DIR directory",
                                       :default => false

    option [ "-r", "--keep-repo" ], :flag,
                                    "don't remove the downloaded configuration repository from the TMP DIR directory",
                                    :default => false

    option [ "-l", "--log-level" ], "LOG LEVEL",
                                    "how much output will Capistrano print out. Can be any of: important, info, debug",
                                    :default => "important"

    option [ "-c", "--conf-repo" ], "REPO URL",
                                    "a git repository with deploy configurations, mainly apps and recipes",
                                    :required => true

    option [ "-b", "--conf-branch" ], "REPO BRANCH",
                                      "specify a branch for the configuration repository",
                                      :default => "master"

    option [ "-d", "--tmp-dir" ], "TMP DIR",
                                  "a directory where to put the configuration repo to build capfile with",
                                  :default => "/tmp/pulsar"

    option [ "-s", "--skip-cap-run" ], :flag,
                                       "do everything pulsar does (build a Capfile) but don't run the cap command",
                                       :default => false

    parameter "APPLICATION", "the application which you would like to deploy"
    parameter "ENVIRONMENT", "the environment on which you would like to deploy" do |env|
      %w(production staging development).include?(env) ? env : raise(ArgumentError)
    end
    parameter "[TASKS] ...", "the tasks/args that will be passed to the final `cap` command", :default => "deploy"

    def execute
      target = "#{application}:#{environment}"

      Bundler.with_clean_env do
        fetch_repo
        bundle_install
        create_capfile
        build_capfile(target)

        unless skip_cap_run?
          cap_args = [tasks_list].flatten.join(" ")
          run_capistrano(cap_args)
        end

        remove_capfile unless keep_capfile?
        remove_repo unless keep_repo?
      end
    end
  end
end
