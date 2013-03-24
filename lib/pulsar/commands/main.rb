module Pulsar
  class MainCommand < Clamp::Command
    include Pulsar::Helpers::Clamp
    include Pulsar::Options::Shared
    include Pulsar::Options::ConfRepo
    
    option [ "-l", "--log-level" ], "LOG LEVEL",
                                    "how much output will Capistrano print out. Can be any of: important, info, debug",
                                    :default => "important"

    option [ "-s", "--skip-cap-run" ], :flag,
                                       "do everything pulsar does (build a Capfile) but don't run the cap command",
                                       :default => false

    parameter "APPLICATION", "the application which you would like to deploy" unless File.exists?("#{Dir.pwd}/config.ru")
    parameter "ENVIRONMENT", "the environment on which you would like to deploy" do |env|
      %w(production staging development).include?(env) ? env : raise(ArgumentError)
    end
    parameter "[TASKS] ...", "the arguments and/or options that will be passed to capistrano", :default => "deploy"

    def execute
      app = application rescue File.basename(Dir.pwd)
      target = "#{app}:#{environment}"

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
