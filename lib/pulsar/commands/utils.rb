module Pulsar
  class UtilsCommand < Clamp::Command
    include Pulsar::Helpers::Clamp

    #
    # Global options
    #
    option [ "-V", "--version" ], :flag, "print out pulsar version" do
      puts(VERSION)
      exit(0)
    end

    option [ "-v", "--verbose" ], :flag, "print out what pulsar is doing", :default => false 

    #
    # Sub commands
    #
    subcommand "list", "list all available apps and environments which you can deploy", ListCommand
    subcommand "init", "generate a new configuration repo with some basic recipes to use with pulsar", InitCommand
  end
end

