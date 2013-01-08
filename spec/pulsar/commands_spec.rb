require 'spec_helper'

describe Pulsar do
  include OutputCapture

  context "MainCommand" do
    let(:pulsar) { Pulsar::MainCommand.new("") }

    context "--version option" do
      before do
        begin
          pulsar.parse(["--version"])
        rescue SystemExit => e
          @system_exit = e
        end
      end

      it "shows version" do
        stdout.should include(Pulsar::VERSION)
      end

      it "exits with a zero status" do
        @system_exit.should_not be_nil
        @system_exit.status.should == 0
      end
    end

    context "subcommands" do
      it "should be cap and list" do
        help = pulsar.help
        help.should =~ /Subcommands:/
        help.should =~ /cap/
        help.should =~ /list/
      end
    end
  end

  context "CapCommand" do
    let(:pulsar) { Pulsar::CapCommand.new("cap") }

    context "--conf-repo option" do
      it "is required" do
        expect { pulsar.parse([""]) }.to raise_error(Clamp::UsageError)
      end
    end

    context "with required args" do
      it "sets variables correctly" do
        pulsar.parse(%w(-c repo.com project development))

        pulsar.conf_repo.should == "repo.com"
        pulsar.application.should == "project"
        pulsar.environment.should == "development"
      end
    end
  end
end
