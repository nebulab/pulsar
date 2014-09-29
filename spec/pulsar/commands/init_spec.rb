require 'spec_helper'

describe Pulsar::InitCommand do
  let(:pulsar) { Pulsar::InitCommand.new("init") }

  it "copies over the configuration repo" do
    expect{ pulsar.run(["#{tmp_path}/new-conf-repo"]) }.to change{ Dir.glob("#{tmp_path}/new-conf-repo").length }.by(1)
  end
end
