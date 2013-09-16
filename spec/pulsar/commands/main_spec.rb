require 'spec_helper'

describe Pulsar::MainCommand do
  let(:pulsar) { Pulsar::MainCommand.new("") }

  before(:each) { reload_main_command }

  it "builds a Capfile file in tmp dir" do
    expect { pulsar.run(full_cap_args + dummy_app) }.to change{ Dir.glob("#{tmp_path}/capfile-*").length }.by(1)
  end

  it "copies a the repo over to temp directory" do
    expect { pulsar.run(full_cap_args + %w(--keep-repo) + dummy_app) }.to change{ Dir.glob("#{tmp_path}/conf-repo*").length }.by(1)
  end

  it "removes the temp directory even if it's raised an error" do
    Pulsar::MainCommand.any_instance.stub(:run_capistrano) { raise 'error' }
    pulsar.run(base_args + [ "--tmp-dir", tmp_path, "--keep-capfile" ] + dummy_app) rescue nil

    Dir.glob("#{tmp_path}/conf-repo*").should be_empty
  end

  it "copies a the repo when there is a dir with same name" do
    system("mkdir #{tmp_path}/conf-repo")
    expect { pulsar.run(full_cap_args + %w(--keep-repo) + dummy_app) }.to change{ Dir.glob("#{tmp_path}/conf-repo*").length }.by(1)
  end

  it "uses dirname when inside a rack app directory" do
    FileUtils.cd(dummy_rack_app_path) do
      reload_main_command

      expect { pulsar.run(full_cap_args + %w(production)) }.to change{ Dir.glob("#{tmp_path}/capfile-*").length }.by(1)
    end
  end

  it "supports multiple apps via comma separated argument" do
    apps_to_deploy = [ 'dummy_app,other_dummy_app', 'production' ]

    expect { pulsar.run(full_cap_args + apps_to_deploy) }.to change{ Dir.glob("#{tmp_path}/capfile-*").length }.by(2)
  end

  context "dotfile options" do
    it "reads configuration variables from .pulsar file in home" do
      stub_dotfile(Dir.home, dummy_dotfile_options)

      pulsar.run(full_cap_args + dummy_app)

      ENV.to_hash.should include(dummy_dotfile_options)
    end

    it "reads configuration variables from .pulsar file in rack app directory" do
      stub_dotfile(dummy_rack_app_path, dummy_dotfile_options)

      FileUtils.cd(dummy_rack_app_path) do
        reload_main_command

        pulsar.run(full_cap_args + %w(production))
      end

      ENV.to_hash.should include(dummy_dotfile_options)
    end

    it "skips lines which cannot parse when reading .pulsar file" do
      stub_dotfile(dummy_rack_app_path, [ "wrong_line", "# comment"])

      FileUtils.cd(dummy_rack_app_path) do
        reload_main_command

        expect { pulsar.run(full_cap_args + %w(production)) }.not_to raise_error
      end
    end

    it "falls back to .pulsar file in home directory if it's not in the rack app directory" do
      stub_dotfile(Dir.home, dummy_dotfile_options)

      File.stub(:file?).with("#{File.expand_path(dummy_rack_app_path)}/.pulsar").and_return(false)

      FileUtils.cd(dummy_rack_app_path) do
        reload_main_command

        pulsar.run(full_cap_args + %w(production))
      end
    end
  end

  it "errors out if application does not exist in configuration repository" do
    expect { pulsar.run(full_cap_args + %w(non_existent_app production)) }.to raise_error(ArgumentError)
  end

  it "errors out if stage does not exist in configuration repository" do
    expect { pulsar.run(full_cap_args + dummy_app(:non_existent_stage)) }.to raise_error(ArgumentError)
  end

  context "Capfile" do
    it "uses base.rb in staging stage" do
      pulsar.run(full_cap_args + dummy_app(:staging))

      latest_capfile.should include("# This is apps/base.rb")
    end

    it "uses base.rb in production stage" do
      pulsar.run(full_cap_args + dummy_app)

      latest_capfile.should include("# This is apps/base.rb")
    end

    it "uses defaults.rb in staging stage" do
      pulsar.run(full_cap_args + dummy_app(:staging))

      latest_capfile.should include("# This is apps/dummy_app/defaults.rb")
    end

    it "uses defaults.rb in production stage" do
      pulsar.run(full_cap_args + dummy_app)

      latest_capfile.should include("# This is apps/dummy_app/defaults.rb")
    end

    it "uses defaults.rb in staging stage only" do
      pulsar.run(full_cap_args + dummy_app(:staging))

      latest_capfile.should include("# This is apps/dummy_app/staging.rb")
      latest_capfile.should_not include("# This is apps/dummy_app/production.rb")
    end

    it "uses defaults.rb in production stage only" do
      pulsar.run(full_cap_args + dummy_app)

      latest_capfile.should include("# This is apps/dummy_app/production.rb")
      latest_capfile.should_not include("# This is apps/dummy_app/staging.rb")
    end

    it "uses custom recipes in staging stage" do
      pulsar.run(full_cap_args + dummy_app(:staging))

      latest_capfile.should include("# This is apps/dummy_app/recipes/custom_recipe.rb")
    end

    it "uses custom recipes in production stage" do
      pulsar.run(full_cap_args + dummy_app)

      latest_capfile.should include("# This is apps/dummy_app/recipes/custom_recipe.rb")
    end

    it "uses custom staging recipes in staging stage only" do
      pulsar.run(full_cap_args + dummy_app(:staging))

      latest_capfile.should include("# This is apps/dummy_app/recipes/staging/custom_recipe.rb")
      latest_capfile.should_not include("# This is apps/dummy_app/recipes/production/custom_recipe.rb")
    end

    it "uses custom production recipes in production stage only" do
      pulsar.run(full_cap_args + dummy_app)

      latest_capfile.should include("# This is apps/dummy_app/recipes/production/custom_recipe.rb")
      latest_capfile.should_not include("# This is apps/dummy_app/recipes/staging/custom_recipe.rb")
    end

    it "uses dirname from PULSAR_APP_NAME when inside a rack app directory" do
      ENV["PULSAR_APP_NAME"] = "other_dummy_app"

      FileUtils.cd(dummy_rack_app_path) do
        reload_main_command
        pulsar.run(full_cap_args + %w(production))
      end

      latest_capfile.should include("# This is apps/other_dummy_app/defaults.rb")
      latest_capfile.should include("# This is apps/other_dummy_app/production.rb")
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
      stdout.should include(Pulsar::VERSION)
    end

    it "exits with a zero status" do
      @system_exit.should_not be_nil
      @system_exit.status.should == 0
    end
  end

  context "--conf-repo option" do
    it "is required" do
      expect { pulsar.parse([]) }.to raise_error(Clamp::UsageError)
    end

    it "supports environment variable" do
      ENV["PULSAR_CONF_REPO"] = dummy_conf_path
      expect { pulsar.parse(dummy_app) }.not_to raise_error(Clamp::UsageError)
    end

    it "supports directories" do
      expect { pulsar.run(full_cap_args + dummy_app) }.not_to raise_error(Errno::ENOENT)
    end
  end

  context "--tmp-dir option" do
    it "is supported" do
      expect { pulsar.parse(base_args + %w(--tmp-dir dummy_tmp) + dummy_app) }.to_not raise_error(Clamp::UsageError)
    end

    it "creates the tmp directory if it doesn't exist" do
      run_options = base_args + [ "--tmp-dir", tmp_path("tmp/non_existent"), "--skip-cap-run" ] + dummy_app

      expect { pulsar.run(run_options) }.not_to raise_error
    end
  end

  context "--keep-capfile option" do
    it "is supported" do
      expect { pulsar.parse(base_args + %w(--keep-capfile) + dummy_app) }.to_not raise_error(Clamp::UsageError)
    end
  end

  context "--skip-cap-run option" do
    it "is supported" do
      expect { pulsar.parse(base_args + %w(--skip-cap-run) + dummy_app) }.to_not raise_error(Clamp::UsageError)
    end
  end

  context "--keep-repo option" do
    it "is supported" do
      expect { pulsar.parse(base_args + %w(--keep-repo) + dummy_app) }.to_not raise_error(Clamp::UsageError)
    end
  end

  context "--log-level option" do
    it "is supported" do
      expect { pulsar.parse(base_args + %w(--log-level debug) + dummy_app) }.to_not raise_error(Clamp::UsageError)
    end

    it "supports Capistrano IMPORTANT" do
      pulsar.run(full_cap_args + %w(--log-level important) + dummy_app)

      latest_capfile.should include("logger.level = logger.level = Capistrano::Logger::IMPORTANT")
    end

    it "supports Capistrano INFO" do
      pulsar.run(full_cap_args + %w(--log-level info) + dummy_app)

      latest_capfile.should include("logger.level = logger.level = Capistrano::Logger::INFO")
    end

    it "supports Capistrano DEBUG" do
      pulsar.run(full_cap_args + %w(--log-level debug) + dummy_app)

      latest_capfile.should include("logger.level = logger.level = Capistrano::Logger::DEBUG")
    end

    it "supports Capistrano TRACE" do
      pulsar.run(full_cap_args + %w(--log-level trace) + dummy_app)

      latest_capfile.should include("logger.level = logger.level = Capistrano::Logger::TRACE")
    end
  end

  context "TASKS parameter" do
    it "defaults to deploy" do
      pulsar.tasks_list.should == "deploy"
    end

    it "supports environment variable" do
      ENV["PULSAR_DEFAULT_TASK"] = "custom:task"
      pulsar.run(full_cap_args + dummy_app)

      pulsar.tasks_list.should == [ "custom:task" ]
    end
  end
end
