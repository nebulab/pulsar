module Pulsar
  class UtilsCommand < Clamp::Command
    include Pulsar::Helpers::Clamp
    include Pulsar::Options::Shared

    subcommand "list", "list all available apps and environments which you can deploy", ListCommand
    subcommand "init", "generate a new configuration repo with some basic recipes to use with pulsar", InitCommand
  end
end

