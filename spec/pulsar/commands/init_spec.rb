require 'spec_helper'

describe Pulsar::InitCommand do
  let(:pulsar) { Pulsar::InitCommand.new("init") }

  it "copies over the configuration repo" do
    expect{ pulsar.run(["#{spec_tmp_path}/new-conf-repo"]) }.to change{ Dir.glob("#{spec_tmp_path}/new-conf-repo").length }.by(1)
  end
end
