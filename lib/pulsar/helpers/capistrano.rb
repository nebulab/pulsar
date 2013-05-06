module Pulsar
  module Helpers
    module Capistrano
      class DSL
        include Pulsar::Helpers::Clamp

        def initialize(cap_conf, &dsl_code)
          @cap_conf = cap_conf
          instance_eval(&dsl_code)
        end

        def method_missing(meth, *args, &block)
          recipes = "#{ENV['CONFIG_PATH']}/recipes/#{meth}"

          File.directory?(recipes) || raise("There are no recipes of type #{meth}")

          args.each do |arg|
            recipe = "#{recipes}/#{arg}.rb"
            File.exists?(recipe) || raise("There is no #{arg} recipe")

            @cap_conf.send(:load, recipe)
          end
        end
      end

      def load_recipes(&block)
        DSL.new(self, &block)
      end

      def from_application_path?
        ENV.has_key?('APP_PATH')
      end
    end
  end
end
