require 'spec_helper'

describe Pulsar::MainCommand do
  include OutputCapture

  context "with required arguments" do
    before do
      @pulsar = Pulsar::CapCommand.new("cap")
      @pulsar.parse(%w(-c repo.com project development))
    end

    it "should set variables correctly" do
      @pulsar.conf_repo.should == "repo.com"
      @pulsar.application.should == "project"
      @pulsar.environment.should == "development"
    end
  end
end