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

    parameter "[TASKS] ...",
              "the arguments and/or options that will be passed to capistrano",
              :environment_variable => "PULSAR_DEFAULT_TASK",
              :default => "deploy"

    def execute
      find_apps.each do |app|
        Bundler.with_clean_env do
          begin
            create_tmp_dir
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
      apps = if from_application_path?
               [ ENV['PULSAR_APP_NAME'] || File.basename(application_path) ]
             else
               expand_app_list application
             end

      apps
    end

    def cleanup!
      remove_capfile unless keep_capfile?
      remove_repo unless keep_repo?

      reset_for_other_app!
    end

    # Given following applications:
    # pulsar_repo/
    #   apps/
    #     app1
    #     app2
    #     app3-web
    #     app3-worker
    #     app4
    # it turns app1,app2,app3* into
    #
    # [ app1, app2, app3-web, app3-worker ]
    def expand_app_list applications
      app_list = Set.new

      applications.split(',').each do |application_name|
        # application_name has a pattern!
        if application_name["*"]
          # get all directories which match it
          pattern = "#{@conf_repo}/apps/#{application_name}"
          Dir.glob(pattern).each do |matched|
            path = File.expand_path matched

            # only add application to set if it's a directory
            if File.directory? path
              app_list << File.basename(path)
            end
          end
        else
          # normal, single arg mode
          app_list << application_name
        end
      end

      app_list.to_a
    end
  end
end
