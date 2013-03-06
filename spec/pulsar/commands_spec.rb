require 'spec_helper'

describe Pulsar do
  include Helpers
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

    context "--tmp-dir option" do
      it "is supported" do
        expect { pulsar.parse(base_args + %w(--tmp-dir dummy_tmp)) }.to_not raise_error(Clamp::UsageError)
      end
    end

    context "--keep-capfile option" do
      it "is supported" do
        expect { pulsar.parse(base_args + %w(--keep-capfile)) }.to_not raise_error(Clamp::UsageError)
      end
    end
  end

  context "ListCommand" do
    let(:pulsar) { Pulsar::CapCommand.new("list") }

    context "--conf-repo option" do
      it "is required" do
        expect { pulsar.parse([""]) }.to raise_error(Clamp::UsageError)
      end
    end
    
    context "--tmp-dir option" do
      it "is supported" do
        expect { pulsar.parse(base_args + %w(--tmp-dir dummy_tmp)) }.to_not raise_error(Clamp::UsageError)
      end
    end

    context "--keep-capfile option" do
      it "is supported" do
        expect { pulsar.parse(base_args + %w(--keep-capfile)) }.to_not raise_error(Clamp::UsageError)
      end
    end
  end
end
