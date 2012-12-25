module Pulsar
  module Helpers
    module Capistrano
      require "pulsar/helpers/clamp"

      class DSL
        include Pulsar::Helpers::Clamp

        def initialize(cap_conf, &dsl_code)
          @cap_conf = cap_conf
          instance_eval(&dsl_code)
        end

        def method_missing(meth, *args, &block)
          if File.directory?("#{config_path}/recipes/#{meth}")
            args.each do |arg|
              @cap_conf.load("#{config_path}/recipes/#{meth}/#{arg}.rb")
            end
          else
            super
          end
        end
      end

      def load_recipes(&block)
        DSL.new(self, &block)
      end
    end
  end
end
