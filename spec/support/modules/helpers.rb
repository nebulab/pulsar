module Helpers
  def base_args
    [ "--conf-repo", dummy_conf_path ]
  end

  def full_cap_args
    base_args + [ "--tmp-dir", tmp_path, "--keep-capfile", "--skip-cap-run" ]
  end

  def full_list_args
    base_args + [ "--tmp-dir", tmp_path, "--keep-capfile" ]
  end

  def dummy_conf_path
    File.join(File.dirname(__FILE__), "..", "dummy_conf")
  end

  def tmp_path
    File.join(File.dirname(__FILE__), "..", "tmp")
  end

  def dummy_app(stage = :production)
    [ "dummy_app", stage.to_s ]
  end

  def latest_capfile
    capfile = File.open(Dir.glob("#{tmp_path}/capfile-*").first)
    content = capfile.read
    capfile.close
    
    content
  end
end
