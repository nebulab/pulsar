module Pulsar
  class MainCommand < Clamp::Command
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
    subcommand "cap", "build a capfile from configuration repo and execute the cap command on it", CapCommand
    subcommand "list", "list all available apps and environments which you can deploy", ListCommand
  end
end
