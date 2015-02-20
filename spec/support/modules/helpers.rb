module Helpers
  def base_args
    ['--conf-repo', dummy_conf_path]
  end

  def capfile_count
    Dir.glob("#{spec_tmp_path}/tmp/capfile-*").length
  end

  def dummy_app(stage = :production)
    ['dummy_app', stage.to_s]
  end

  def dummy_conf_path
    File.join(File.dirname(__FILE__), '..', 'dummies', 'dummy_conf')
  end

  def dummy_dotfile_options
    {
      'PULSAR_APP_NAME'     => 'dummy_app',
      'PULSAR_CONF_REPO'    => dummy_conf_path,
      'PULSAR_DEFAULT_TASK' => 'capistrano:task'
    }
  end

  def dummy_app_path
    File.join(File.dirname(__FILE__), '..', 'dummies', 'dummy_app')
  end

  def full_cap_args
    base_args +
      ['--home-dir', spec_tmp_path, '--keep-capfile', '--skip-cap-run']
  end

  def full_list_args
    base_args + ['--home-dir', spec_tmp_path, '--keep-capfile']
  end

  def hash_to_env_vars(hash)
    dotfile_lines = []

    hash.each do |option, value|
      if value.nil?
        dotfile_lines << option
      else
        dotfile_lines << "#{option}=\"#{value}\"\n"
      end
    end

    dotfile_lines
  end

  def latest_capfile
    capfile = File.open(Dir.glob("#{spec_tmp_path}/tmp/capfile-*").first)
    content = capfile.read
    capfile.close

    content
  end

  def reload_main_command
    Pulsar.instance_eval{ remove_const :MainCommand }
    load 'pulsar/commands/main.rb'

    stub_bundle_install
  end

  def spec_tmp_path
    File.join(File.dirname(__FILE__), '..', 'tmp')
  end

  def stub_bundle_install
    allow_any_instance_of(Pulsar::MainCommand).to receive(:bundle_install)
  end

  def stub_config(path, options)
    extended_path = File.expand_path(path)

    allow(File).to receive(:file?).and_return(false)
    allow(File).to receive(:file?).with(extended_path).and_return(true)
    allow(File)
      .to receive(:readlines)
      .with(extended_path).and_return(hash_to_env_vars(options))
  end
end
