require 'spec_helper'

describe Pulsar::Helpers::Capistrano do
  include Pulsar::Helpers::Capistrano

  context "load_recipes" do
    it "loads capistrano recipes from CONFIG_PATH env variable" do
      ENV['CONFIG_PATH'] = "/config/path"
      allow(File).to receive(:directory?).and_return(true)
      allow(File).to receive(:exist?).and_return(true)
      allow(self).to receive(:load)

      load_recipes { generic :recipe }

      expect(self).to have_received(:load).with("/config/path/recipes/generic/recipe.rb")
    end

    it "raises a missing recipe type exception when no recipe folder is found" do
      allow(File).to receive(:directory?).and_return(false)

      expect{ load_recipes { generic :recipe } }.to raise_error(RuntimeError, /no recipes of type generic/)
    end

    it "raises a missing recipe exception when no recipe is found" do
      allow(File).to receive(:directory?).and_return(true)
      allow(File).to receive(:exist?).and_return(false)

      expect{ load_recipes { generic :missing_recipe } }.to raise_error(RuntimeError, /no missing_recipe recipe/)
    end

    it "does not call load if :app_only is true and pulsar is not called from inside application" do
      ENV.delete('APP_PATH')
      allow(File).to receive(:directory?).and_return(true)
      allow(File).to receive(:exist?).and_return(true)
      allow(self).to receive(:load)

      load_recipes(:app_only => true) { generic :recipe }

      expect(self).not_to have_received(:load)
    end

    it "calls load if :app_only is true and pulsar is called from inside application" do
      ENV['APP_PATH'] = "/app/path"
      allow(File).to receive(:directory?).and_return(true)
      allow(File).to receive(:exist?).and_return(true)
      allow(self).to receive(:load)

      load_recipes(:app_only => true) { generic :recipe }

      expect(self).to have_received(:load)
    end
  end

  context "from_application_path?" do
    it "returns true if APP_PATH env variable is set" do
      ENV['APP_PATH'] = "/app/path"

      expect(from_application_path?).to be true
    end

    it "returns false if APP_PATH env variable is not set" do
      ENV.delete('APP_PATH')

      expect(from_application_path?).to be false
    end
  end
end
