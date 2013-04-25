require 'spec_helper'

describe Pulsar::Helpers::Capistrano do
  include Pulsar::Helpers::Capistrano

  context "load_recipes" do
    it "loads capistrano recipes from CONFIG_PATH env variable" do
      ENV['CONFIG_PATH'] = "/config/path"
      File.stub(:directory?).and_return(true)
      
      self.should_receive(:load).with("/config/path/recipes/generic/recipe.rb")

      load_recipes { generic :recipe }
    end
  end
end
