require 'spec_helper'

describe Pulsar::MainCommand do
  let(:pulsar) { Pulsar::MainCommand.new("") }

  before(:each) { reload_main_command }

  it "builds a Capfile file in tmp dir" do
    expect{ pulsar.run(full_cap_args + dummy_app) }.to change{ capfile_count }.by(1)
  end

  it "copies a the repo over to temp directory" do
    expect{ pulsar.run(full_cap_args + %w(--keep-repo) + dummy_app) }.to change{ capfile_count }.by(1)
  end

  it "removes the temp directory even if it's raised an error" do
    allow_any_instance_of(Pulsar::MainCommand).to receive(:run_capistrano) { raise 'error' }
    pulsar.run(base_args + [ "--tmp-dir", tmp_path, "--keep-capfile" ] + dummy_app) rescue nil

    expect(Dir.glob("#{tmp_path}/pulsar-conf-repo*")).to be_empty
  end

  it "copies a the repo when there is a dir with same name" do
    system("mkdir #{tmp_path}/pulsar-conf-repo")
    expect{ pulsar.run(full_cap_args + %w(--keep-repo) + dummy_app) }.to change{ Dir.glob("#{tmp_path}/pulsar-conf-repo*").length }.by(1)
  end

  it "uses dirname when inside a rack app directory" do
    FileUtils.cd(dummy_rack_app_path) do
      reload_main_command

      expect{ pulsar.run(full_cap_args + %w(production)) }.to change{ capfile_count }.by(1)
    end
  end

  context "Multiple applications" do
    let :stage do
      "production"
    end

    let :comma_separated_list do
      [ 'dummy_app,other_dummy_app', stage ]
    end

    let :pattern_list do
      [ 'dummy*', stage ]
    end

    let :pattern_match_all do
      [ '*', stage ]
    end

    let :double_pattern do
      [ 'dummy*,*app', stage ]
    end

    it "supports multiple apps via comma separated argument" do
      expect{ pulsar.run(full_cap_args + comma_separated_list) }.to change{ capfile_count }.by(2)
    end

    it "supports pattern matching on app names" do
      expect{ pulsar.run(full_cap_args + pattern_list) }.to change{ capfile_count }.by(1)
    end

    it "matches all apps with *" do
      expect{ pulsar.run(full_cap_args + pattern_match_all) }.to change { capfile_count }.by(2)
    end

    it "matches application only once" do
      expect{ pulsar.run(full_cap_args + double_pattern) }.to change { capfile_count }.by(2)
    end
  end

  context "dotfile options" do
    it "reads configuration variables from .pulsar file in home" do
      stub_dotfile(Dir.home, dummy_dotfile_options)

      pulsar.run(full_cap_args + dummy_app)

      expect(ENV.to_hash).to include(dummy_dotfile_options)
    end

    it "reads configuration variables from .pulsar file in rack app directory" do
      stub_dotfile(dummy_rack_app_path, dummy_dotfile_options)

      FileUtils.cd(dummy_rack_app_path) do
        reload_main_command

        pulsar.run(full_cap_args + %w(production))
      end

      expect(ENV.to_hash).to include(dummy_dotfile_options)
    end

    it "skips lines which cannot parse when reading .pulsar file" do
      stub_dotfile(dummy_rack_app_path, [ "wrong_line", "# comment"])

      FileUtils.cd(dummy_rack_app_path) do
        reload_main_command

        expect{ pulsar.run(full_cap_args + %w(production)) }.not_to raise_error
      end
    end

    it "falls back to .pulsar file in home directory if it's not in the rack app directory" do
      stub_dotfile(Dir.home, dummy_dotfile_options)

      allow(File).to receive(:file?).with("#{File.expand_path(dummy_rack_app_path)}/.pulsar").and_return(false)

      FileUtils.cd(dummy_rack_app_path) do
        reload_main_command

        expect{ pulsar.run(full_cap_args + %w(production)) }.not_to raise_error
      end
    end
  end

  it "errors out if application does not exist in configuration repository" do
    expect{ pulsar.run(full_cap_args + %w(non_existent_app production)) }.to raise_error(ArgumentError)
  end

  it "errors out if stage does not exist in configuration repository" do
    expect{ pulsar.run(full_cap_args + dummy_app(:non_existent_stage)) }.to raise_error(ArgumentError)
  end

  context "Capfile" do
    it "uses base.rb in staging stage" do
      pulsar.run(full_cap_args + dummy_app(:staging))

      expect(latest_capfile).to include("# This is apps/base.rb")
    end

    it "uses base.rb in production stage" do
      pulsar.run(full_cap_args + dummy_app)

      expect(latest_capfile).to include("# This is apps/base.rb")
    end

    it "uses defaults.rb in staging stage" do
      pulsar.run(full_cap_args + dummy_app(:staging))

      expect(latest_capfile).to include("# This is apps/dummy_app/defaults.rb")
    end

    it "uses defaults.rb in production stage" do
      pulsar.run(full_cap_args + dummy_app)

      expect(latest_capfile).to include("# This is apps/dummy_app/defaults.rb")
    end

    it "uses defaults.rb in staging stage only" do
      pulsar.run(full_cap_args + dummy_app(:staging))

      expect(latest_capfile).to include("# This is apps/dummy_app/staging.rb")
      expect(latest_capfile).not_to include("# This is apps/dummy_app/production.rb")
    end

    it "uses defaults.rb in production stage only" do
      pulsar.run(full_cap_args + dummy_app)

      expect(latest_capfile).to include("# This is apps/dummy_app/production.rb")
      expect(latest_capfile).not_to include("# This is apps/dummy_app/staging.rb")
    end

    it "uses custom recipes in staging stage" do
      pulsar.run(full_cap_args + dummy_app(:staging))

      expect(latest_capfile).to include("# This is apps/dummy_app/recipes/custom_recipe.rb")
    end

    it "uses custom recipes in production stage" do
      pulsar.run(full_cap_args + dummy_app)

      expect(latest_capfile).to include("# This is apps/dummy_app/recipes/custom_recipe.rb")
    end

    it "uses custom staging recipes in staging stage only" do
      pulsar.run(full_cap_args + dummy_app(:staging))

      expect(latest_capfile).to include("# This is apps/dummy_app/recipes/staging/custom_recipe.rb")
      expect(latest_capfile).not_to include("# This is apps/dummy_app/recipes/production/custom_recipe.rb")
    end

    it "uses custom production recipes in production stage only" do
      pulsar.run(full_cap_args + dummy_app)

      expect(latest_capfile).to include("# This is apps/dummy_app/recipes/production/custom_recipe.rb")
      expect(latest_capfile).not_to include("# This is apps/dummy_app/recipes/staging/custom_recipe.rb")
    end

    it "uses dirname from PULSAR_APP_NAME when inside a rack app directory" do
      ENV["PULSAR_APP_NAME"] = "other_dummy_app"

      FileUtils.cd(dummy_rack_app_path) do
        reload_main_command
        pulsar.run(full_cap_args + %w(production))
      end

      expect(latest_capfile).to include("# This is apps/other_dummy_app/defaults.rb")
      expect(latest_capfile).to include("# This is apps/other_dummy_app/production.rb")
    end
  end

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

  context "--conf-repo option" do
    it "is required" do
      expect{ pulsar.parse([]) }.to raise_error(Clamp::UsageError)
    end

    it "supports environment variable" do
      ENV["PULSAR_CONF_REPO"] = dummy_conf_path
      expect{ pulsar.parse(dummy_app) }.not_to raise_error
    end

    it "supports directories" do
      expect{ pulsar.run(full_cap_args + dummy_app) }.not_to raise_error
    end
  end

  context "--tmp-dir option" do
    it "is supported" do
      expect{ pulsar.parse(base_args + %w(--tmp-dir dummy_tmp) + dummy_app) }.not_to raise_error
    end

    it "creates the tmp directory if it doesn't exist" do
      run_options = base_args + [ "--tmp-dir", tmp_path("tmp/non_existent"), "--skip-cap-run" ] + dummy_app

      expect{ pulsar.run(run_options) }.not_to raise_error
    end
  end

  context "--keep-capfile option" do
    it "is supported" do
      expect{ pulsar.parse(base_args + %w(--keep-capfile) + dummy_app) }.not_to raise_error
    end
  end

  context "--skip-cap-run option" do
    it "is supported" do
      expect{ pulsar.parse(base_args + %w(--skip-cap-run) + dummy_app) }.not_to raise_error
    end
  end

  context "--keep-repo option" do
    it "is supported" do
      expect{ pulsar.parse(base_args + %w(--keep-repo) + dummy_app) }.not_to raise_error
    end
  end

  context "--log-level option" do
    it "is supported" do
      expect{ pulsar.parse(base_args + %w(--log-level debug) + dummy_app) }.not_to raise_error
    end

    it "supports Capistrano IMPORTANT" do
      pulsar.run(full_cap_args + %w(--log-level important) + dummy_app)

      expect(latest_capfile).to include("logger.level = logger.level = Capistrano::Logger::IMPORTANT")
    end

    it "supports Capistrano INFO" do
      pulsar.run(full_cap_args + %w(--log-level info) + dummy_app)

      expect(latest_capfile).to include("logger.level = logger.level = Capistrano::Logger::INFO")
    end

    it "supports Capistrano DEBUG" do
      pulsar.run(full_cap_args + %w(--log-level debug) + dummy_app)

      expect(latest_capfile).to include("logger.level = logger.level = Capistrano::Logger::DEBUG")
    end

    it "supports Capistrano TRACE" do
      pulsar.run(full_cap_args + %w(--log-level trace) + dummy_app)

      expect(latest_capfile).to include("logger.level = logger.level = Capistrano::Logger::TRACE")
    end
  end

  context "TASKS parameter" do
    it "defaults to deploy" do
      expect(pulsar.tasks_list).to eq "deploy"
    end

    it "supports environment variable" do
      ENV["PULSAR_DEFAULT_TASK"] = "custom:task"
      pulsar.run(full_cap_args + dummy_app)

      expect(pulsar.tasks_list).to eq [ "custom:task" ]
    end
  end
end
