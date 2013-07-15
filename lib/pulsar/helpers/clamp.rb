module Pulsar
  module Helpers
    module Clamp
      include Pulsar::Helpers::Shell

      def self.included(base)
        base.extend(InstanceAndClassMethods)
        base.send(:include, InstanceMethods)
      end

      module InstanceAndClassMethods
        def from_application_path?
          File.exists?("#{Dir.pwd}/config.ru")
        end
      end

      module InstanceMethods
        include InstanceAndClassMethods

        def application_path
          Dir.pwd if from_application_path?
        end

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

        def config_path
          @configuration_path ||= "#{tmp_dir}/conf-repo-#{time_to_deploy}"
        end

        def create_capfile
          touch(capfile_path, :verbose => verbose?)
        end

        def each_app
          Dir["#{config_path}/apps/*"].each do |path|
            yield(File.basename(path)) if File.directory?(path)
          end
        end

        def fetch_repo
          if File.directory?(conf_repo)
            fetch_directory_repo(conf_repo)
          else
            if conf_repo =~ /\A[a-zA-Z-]+\/[a-zA-Z-]+\Z/
              fetch_git_repo("git@github.com:#{conf_repo}.git")
            else
              fetch_git_repo(conf_repo)
            end
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
          each_app do |name|
            puts "#{name.cyan}: #{stages_for(name).map(&:magenta).join(', ')}"
          end
        end

        def load_configuration
          unless pulsar_configuration.nil?
            File.readlines(pulsar_configuration).each do |line|
              conf, value = line.split("=")

              ENV[conf] = value.chomp.gsub('"', '') if !conf.nil? && !value.nil?
            end
          end
        end

        def pulsar_configuration
          conf_file = ".pulsar"
          inside_app = File.join(application_path, conf_file) rescue nil
          inside_home = File.join(Dir.home, conf_file) rescue nil

          return inside_app if inside_app && File.file?(inside_app)
          return inside_home if inside_home && File.file?(inside_home)
        end

        def remove_capfile
          rm_rf(capfile_path, :verbose => verbose?)
        end

        def remove_repo
          rm_rf(config_path, :verbose => verbose?)
        end

        def reset_for_other_app!
          @capfile_name = @configuration_path = @now = nil
        end

        def run_capistrano(args)
          cmd = "bundle exec cap"
          env = "CONFIG_PATH=#{config_path}"
          opts = "--file #{capfile_path}"

          env += " APP_PATH=#{application_path}" unless application_path.nil?

          cd(config_path, :verbose => verbose?) do
            run_cmd("#{cmd} #{env} #{opts} #{args}", :verbose => verbose?)
          end
        end

        def set_log_level
          level = log_level.upcase
          levels = %w(IMPORTANT INFO DEBUG TRACE)

          level = levels.first unless levels.include?(level)

          cmd = "echo 'logger.level = logger.level = Capistrano::Logger::#{level}' >> #{capfile_path}"

          run_cmd(cmd, :verbose => verbose?)
        end

        def stages_for(app)
          environments = %w(development staging production)

          Dir["#{config_path}/apps/#{app}/*"].map do |env|
            env_name = File.basename(env, '.rb')

            env_name if environments.include?(env_name)
          end.compact
        end

        def time_to_deploy
          @now ||= Time.now.strftime("%Y-%m-%d-%H%M%S-s#{rand(9999)}")
        end
      end
    end
  end
end
