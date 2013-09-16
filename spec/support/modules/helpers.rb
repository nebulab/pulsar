module Helpers
  def base_args
    [ "--conf-repo", dummy_conf_path ]
  end

  def dummy_app(stage = :production)
    [ "dummy_app", stage.to_s ]
  end

  def dummy_conf_path
    File.join(File.dirname(__FILE__), "..", "dummies", "dummy_conf")
  end

  def dummy_dotfile_options
    {
      "PULSAR_APP_NAME" => "dummy_app",
      "PULSAR_CONF_REPO" => dummy_conf_path,
      "PULSAR_DEFAULT_TASK" => "capistrano:task"
    }
  end

  def dummy_rack_app_path
    File.join(File.dirname(__FILE__), "..", "dummies", "dummy_app")
  end

  def full_cap_args
    base_args + [ "--tmp-dir", tmp_path, "--keep-capfile", "--skip-cap-run" ]
  end

  def full_list_args
    base_args + [ "--tmp-dir", tmp_path, "--keep-capfile" ]
  end

  def latest_capfile
    capfile = File.open(Dir.glob("#{tmp_path}/capfile-*").first)
    content = capfile.read
    capfile.close

    content
  end

  def capfile_count
    Dir.glob("#{tmp_path}/capfile-*").length
  end

  def reload_main_command
    Pulsar.instance_eval{ remove_const :MainCommand }
    load "pulsar/commands/main.rb"

    stub_bundle_install
  end

  def stub_bundle_install
    Pulsar::MainCommand.any_instance.stub(:bundle_install)
  end

  def stub_dotfile(path, options)
    extended_path = "#{File.expand_path(path)}/.pulsar"
    dotfile_lines = []

    options.each do |option, value|
      if value.nil?
        dotfile_lines << option
      else
        dotfile_lines << "#{option}=\"#{value}\"\n"
      end
    end

    File.stub(:file?).and_return(true)
    File.stub(:readlines).with(extended_path).and_return(dotfile_lines)
  end

  def tmp_dir
    "tmp"
  end

  def tmp_path(dir=tmp_dir)
    File.join(File.dirname(__FILE__), "..", dir)
  end
end
