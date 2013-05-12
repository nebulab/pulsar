require 'spec_helper'

describe Pulsar::ListCommand do
  let(:pulsar) { Pulsar::ListCommand.new("list") }

  it "copies a the repo over to temp directory" do
    expect { pulsar.run(full_list_args + %w(--keep-repo)) }.to change{ Dir.glob("#{tmp_path}/conf-repo*").length }.by(1)
  end

  it "copies a the repo when there is a dir with same name" do
    system("mkdir #{tmp_path}/conf-repo")
    expect { pulsar.run(full_list_args + %w(--keep-repo)) }.to change{ Dir.glob("#{tmp_path}/conf-repo*").length }.by(1)
  end

  it "removes the temp directory even if it's raised an error" do
    Pulsar::ListCommand.any_instance.stub(:list_apps) { raise 'error' }
    pulsar.run(full_list_args) rescue nil

    Dir.glob("#{tmp_path}/conf-repo*").should be_empty
  end

  it "lists configured apps and stages" do
    app_one = Regexp.escape("dummy_app".cyan)
    app_two = Regexp.escape("other_dummy_app".cyan)
    
    stages = [ "production".magenta, "staging".magenta ]
    escaped_stages = Regexp.escape(stages.join(', '))
    reversed_stages = Regexp.escape(stages.reverse.join(', '))

    pulsar.run(full_list_args)

    stdout.should match(/#{app_one}: (#{escaped_stages})|(#{reversed_stages})/)
    stdout.should match(/#{app_two}: (#{escaped_stages})|(#{reversed_stages})/)
  end

  it "reads configuration variables from .pulsar file in home" do
    env_vars = [ "PULSAR_CONF_REPO=\"#{dummy_conf_path}\"\n"] 

    File.stub(:file?).and_return(true)
    File.stub(:readlines).with("#{Dir.home}/.pulsar").and_return(env_vars)

    pulsar.run(full_list_args)

    ENV.should have_key('PULSAR_CONF_REPO')
    ENV['PULSAR_CONF_REPO'].should == dummy_conf_path
  end

  it "reads configuration variables from .pulsar file in rack app directory" do
    env_vars = [ "PULSAR_CONF_REPO=\"#{dummy_conf_path}\"\n"] 

    File.stub(:file?).and_return(true)
    File.stub(:readlines).with("#{File.expand_path(dummy_rack_app_path)}/.pulsar").and_return(env_vars)

    FileUtils.cd(dummy_rack_app_path) do
      reload_main_command

      pulsar.run(full_list_args)
    end

    ENV.should have_key('PULSAR_CONF_REPO')
    ENV['PULSAR_CONF_REPO'].should == dummy_conf_path
  end

  it "skips lines which cannot parse when reading .pulsar file" do
    env_vars = [ "wrong_line", "# comment"] 

    File.stub(:file?).and_return(true)
    File.stub(:readlines).with("#{File.expand_path(dummy_rack_app_path)}/.pulsar").and_return(env_vars)

    FileUtils.cd(dummy_rack_app_path) do
      reload_main_command

      expect { pulsar.run(full_list_args) }.not_to raise_error
    end
  end

  it "falls back to .pulsar file in home directory if it's not in the rack app directory" do
    env_vars = [ "PULSAR_APP_NAME=\"dummy_app\"\n", "PULSAR_CONF_REPO=\"#{dummy_conf_path}\"\n"] 

    File.stub(:file?).and_return(true)
    File.stub(:file?).with("#{File.expand_path(dummy_rack_app_path)}/.pulsar").and_return(false)

    File.should_receive(:readlines).with("#{Dir.home}/.pulsar").and_return(env_vars)

    FileUtils.cd(dummy_rack_app_path) do
      reload_main_command

      pulsar.run(full_list_args)
    end
  end

  context "--conf-repo option" do
    it "is required" do
      expect { pulsar.parse([]) }.to raise_error(Clamp::UsageError)
    end

    it "supports environment variable" do
      ENV["PULSAR_CONF_REPO"] = dummy_conf_path
      expect { pulsar.parse([]) }.not_to raise_error(Clamp::UsageError)
    end
    
    it "supports directories" do
      expect { pulsar.run(full_list_args) }.not_to raise_error(Errno::ENOENT)
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
