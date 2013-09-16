module Pulsar
  module Options
    module Shared
      def self.included(base)
        base.option [ "-V", "--version" ], :flag, "print out pulsar version" do
          puts(VERSION)
          exit(0)
        end

        base.option [ "-v", "--verbose" ], :flag, "print out what pulsar is doing", :default => false
      end
    end
  end
end
