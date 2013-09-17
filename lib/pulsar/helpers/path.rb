module Pulsar
  module Helpers
    module Path
      def capfile_path
        "#{tmp_dir}/capfile-#{time_to_deploy}"
      end

      def config_path
        "#{tmp_dir}/conf-repo-#{time_to_deploy}"
      end

      def config_app_path(app)
        "#{config_apps_path}/#{app}"
      end

      def config_app_defaults_path(app)
        "#{config_app_path(app)}/defaults.rb"
      end

      def config_app_recipes_path(app)
        "#{config_app_path(app)}/recipes"
      end

      def config_app_stage_recipes_path(app, stage)
        "#{config_app_recipes_path(app)}/#{stage}"
      end

      def config_apps_path
        "#{config_path}/apps"
      end

      def config_base_path
        "#{config_apps_path}/base.rb"
      end

      def config_stage_path(app, stage)
        "#{config_app_path(app)}/#{stage}.rb"
      end

      private
      def time_to_deploy
        @now ||= Time.now.strftime("%Y-%m-%d-%H%M%S-s#{rand(9999)}")
      end
    end
  end
end
