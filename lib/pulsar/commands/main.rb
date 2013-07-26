require "shellwords"

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
      parameter "APPLICATION", "the application which you would like to deploy. Pass a comma separated list to deploy multiple applications at once"
    end

    parameter "STAGE", "the stage on which you would like to deploy"

    parameter "[TASKS] ...", "the arguments and/or options that will be passed to capistrano", :default => "deploy"

    def execute
      find_apps.each do |app|
        Bundler.with_clean_env do
          begin
            fetch_repo
            validate(app, stage)
            bundle_install
            create_capfile
            build_capfile(app, stage)

            unless skip_cap_run?
              cap_args = [ tasks_list ].flatten.shelljoin
              run_capistrano(cap_args)
            end
          ensure
            cleanup!
          end
        end
      end
    end

    private

    def find_apps
      if from_application_path?
        [ ENV['PULSAR_APP_NAME'] || File.basename(application_path) ]
      else
        application.split(',')
      end
    end

    def cleanup!
      remove_capfile unless keep_capfile?
      remove_repo unless keep_repo?

      reset_for_other_app!
    end
  end
end
