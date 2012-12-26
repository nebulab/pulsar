require 'fileutils'

module Pulsar
  module Helpers
    module Clamp
      include FileUtils
      
      def build_capfile(args)
        app, stage = args.split(":")

        # Variables
        set_log_level
        include_base_conf
        include_app(app, stage) if app

        # Recipes
        include_app_recipes(app, stage) if app
      end

      def bundle_install
        FileUtils.cd(config_path, :verbose => verbose?) do
          run_cmd("bundle install --quiet", :verbose => verbose?)
        end
      end

      def capfile_path
        @capfile_name ||= "/tmp/pulsar/capfile-#{Time.now.strftime("%Y-%m-%d-%H%M%S")}"
      end

      def config_path
        @configuration_path ||= "/tmp/pulsar/conf_repo"
      end

      def create_capfile
        touch(capfile_path, :verbose => verbose?)
      end

      def fetch_repo
        repo = !conf_repo.include?(':') ? "git@github.com:#{conf_repo}.git" : conf_repo
        git_options = "--quiet --depth=1 --branch #{conf_branch}"
        run_cmd("git clone #{git_options} #{repo} #{config_path}", :verbose => verbose?)
      end

      def include_app(app, stage=nil)
        app_file = "#{config_path}/apps/#{app}/defaults.rb"
        stage_file = "#{config_path}/apps/#{app}/#{stage}.rb"

        if File.exists?(app_file)
          run_cmd("cat #{app_file} >> #{capfile_path}", :verbose => verbose?)
        end

        if stage
          run_cmd("cat #{stage_file} >> #{capfile_path}", :verbose => verbose?)
        end
      end

      def include_app_recipes(app, stage=nil)
        recipes_dir = "#{config_path}/apps/#{app}/recipes"

        Dir.glob("#{recipes_dir}/*.rb").each do |recipe|
          run_cmd("cat #{recipe} >> #{capfile_path}", :verbose => verbose?)
        end

        if stage
          Dir.glob("#{recipes_dir}/#{stage}/*.rb").each do |recipe|
            run_cmd("cat #{recipe} >> #{capfile_path}", :verbose => verbose?)
          end
        end
      end

      def include_base_conf
        run_cmd("cat #{config_path}/apps/base.rb >> #{capfile_path}", :verbose => verbose?)
      end

      def list_apps
        apps = Dir["#{config_path}/apps/*"].each do |app|
          if File.directory?(app)
            app_name = File.basename(app)
            app_envs = []

            Dir["#{app}/*"].each do |env|
              environments = %w(development staging production)
              env_name = File.basename(env, '.rb')

              if environments.include?(env_name)
                app_envs << env_name
              end
            end

            puts "#{app_name}: #{app_envs.join(', ')}"
          end
        end
      end

      def remove_capfile
        rm_rf(capfile_path, :verbose => verbose?)
      end

      def remove_repo
        rm_rf(config_path, :verbose => verbose?)
      end

      def run_capistrano(args)
        FileUtils.cd(config_path, :verbose => verbose?) do
          run_cmd("bundle exec cap --file #{capfile_path} #{args}", :verbose => verbose?)
        end
      end

      def run_cmd(cmd, opts)
        puts cmd if opts[:verbose]
        system(cmd)
      end

      def set_log_level
        level = log_level.upcase
        levels = %w(IMPORTANT INFO DEBUG)

        level = levels.first unless levels.include?(level)

        cmd = "echo 'logger.level = logger.level = Capistrano::Logger::#{level}' >> #{capfile_path}"

        run_cmd(cmd, :verbose => verbose?)
      end
    end
  end
end
