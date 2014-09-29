require 'spec_helper'

describe Pulsar::UtilsCommand do
  let(:pulsar) { Pulsar::UtilsCommand.new("") }

  context "--version option" do
    before do
      begin
        pulsar.parse(["--version"])
      rescue SystemExit => e
        @system_exit = e
      end
    end

    it "shows version" do
      expect(stdout).to include(Pulsar::VERSION)
    end

    it "exits with a zero status" do
      expect(@system_exit).not_to be_nil
      expect(@system_exit.status).to be 0
    end
  end

  context "subcommands" do
    it "should be cap and list and init" do
      help = pulsar.help
      expect(help).to match(/Subcommands:/)
      expect(help).to match(/list/)
      expect(help).to match(/init/)
    end
  end
end
