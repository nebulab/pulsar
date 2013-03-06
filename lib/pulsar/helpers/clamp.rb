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
        cd(config_path, :verbose => verbose?) do
          run_cmd("bundle install --quiet", :verbose => verbose?)
        end
      end

      def capfile_path
        @capfile_name ||= "#{tmp_dir}/capfile-#{time_to_deploy}"
      end

      def cd(path, opts, &block)
        puts "Directory: #{path.white}".yellow if opts[:verbose]
        FileUtils.cd(path) { yield }
      end

      def config_path
        @configuration_path ||= "#{tmp_dir}/conf-repo-#{time_to_deploy}"
      end

      def create_capfile
        touch(capfile_path, :verbose => verbose?)
      end

      def fetch_repo
        if conf_repo =~ /\A[a-zA-Z-]+\/[a-zA-Z-]+\Z/
          fetch_git_repo("git@github.com:#{conf_repo}.git")
        else
          fetch_directory_repo(conf_repo)
        end
      end

      def fetch_directory_repo(repo)
        if File.directory?("#{repo}/.git")
          fetch_git_repo(repo)
        else
          run_cmd("cp -rp #{repo} #{config_path}", :verbose => verbose?)
        end
      end

      def fetch_git_repo(repo)
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

            puts "#{app_name.cyan}: #{app_envs.map(&:magenta).join(', ')}"
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
        cd(config_path, :verbose => verbose?) do
          run_cmd("CONFIG_PATH=#{config_path} bundle exec cap --file #{capfile_path} #{args}", :verbose => verbose?)
        end
      end

      def rm_rf(path, opts)
        puts "Remove: #{path.white}".yellow if opts[:verbose]
        FileUtils.rm_rf(path)
      end

      def run_cmd(cmd, opts)
        puts "Command: #{cmd.white}".yellow if opts[:verbose]
        system(cmd)

        raise "Command #{cmd} Failed" if $? != 0
      end

      def set_log_level
        level = log_level.upcase
        levels = %w(IMPORTANT INFO DEBUG)

        level = levels.first unless levels.include?(level)

        cmd = "echo 'logger.level = logger.level = Capistrano::Logger::#{level}' >> #{capfile_path}"

        run_cmd(cmd, :verbose => verbose?)
      end

      def time_to_deploy
        @now ||= Time.now.strftime("%Y-%m-%d-%H%M%S-s#{rand(9999)}")
      end

      def touch(file, opts)
        puts "Touch: #{file.white}".yellow if opts[:verbose]
        FileUtils.touch(file)
      end
    end
  end
end
