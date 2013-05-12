module Pulsar
  module Helpers
    module Capistrano
      class DSL
        include Pulsar::Helpers::Clamp

        def initialize(capistrano, opts, &dsl_code)
          @capistrano = capistrano
          @options = opts
          instance_eval(&dsl_code)
        end

        def method_missing(meth, *args, &block)
          return if !@capistrano.from_application_path? && @options[:app_only]

          recipes = "#{ENV['CONFIG_PATH']}/recipes/#{meth}"

          File.directory?(recipes) || raise("There are no recipes of type #{meth}")

          args.each do |arg|
            recipe = "#{recipes}/#{arg}.rb"
            File.exists?(recipe) || raise("There is no #{arg} recipe")

            @capistrano.send(:load, recipe)
          end
        end
      end

      #
      # This method can be called directly inside 
      # capistrano configurations but needs:
      #
      # defer { from_application_path? }
      #
      # otherwise capistrano will interpret it 
      # as a variable and error out
      #
      def from_application_path?
        ENV.has_key?('APP_PATH')
      end

      def load_recipes(opts = {}, &block)
        DSL.new(self, opts, &block)
      end
    end
  end
end
