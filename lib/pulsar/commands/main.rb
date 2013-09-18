module Pulsar
  class MainCommand < Clamp::Command
    include Pulsar::Helpers::Clamp
    include Pulsar::Options::Shared
    include Pulsar::Options::ConfRepo

    option [ "-l", "--log-level" ], "LOG LEVEL",
                                    "how much output will Capistrano print out. Can be any of: important, info, debug, trace",
                                    :default => "important"

    option [ "-s", "--skip-cap-run" ], :flag,
                                       "do everything pulsar does (build a Capfile) but don't run the cap command",
                                       :default => false

    if !from_application_path?
      parameter "APPLICATIONS", "the applications which you would like to deploy. You can pass just one or a comma separated list to deploy multiple applications at once. It supports globbing too."
    end

    parameter "STAGE", "the stage on which you would like to deploy"

    parameter "[TASKS] ...",
              "the arguments and/or options that will be passed to capistrano",
              :environment_variable => "PULSAR_DEFAULT_TASK",
              :default => "deploy"

    def execute
      with_clean_env_and_supported_vars do
        begin
          create_tmp_dir
          fetch_repo
          bundle_install

          expand_applications.each do |app|
            validate(app, stage)
            create_capfile
            build_capfile(app, stage)

            unless skip_cap_run?
              cap_args = [ tasks_list ].flatten.shelljoin
              run_capistrano(cap_args)
            end

            remove_capfile unless keep_capfile?
            reset_capfile_path!
          end
        ensure
          remove_capfile unless keep_capfile?
          remove_repo unless keep_repo?
        end
      end
    end
  end
end
