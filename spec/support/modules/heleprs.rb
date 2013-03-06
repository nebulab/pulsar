module Helpers
  def base_args
    [ "--conf-repo", dummy_conf_path ]
  end

  def full_args
    [ "--conf-repo", dummy_conf_path, "--tmp-dir", tmp_path, "--keep-capfile", "--skip-cap-run" ]
  end

  def dummy_conf_path
    File.join(File.dirname(__FILE__), "..", "dummy_conf")
  end

  def tmp_path
    File.join(File.dirname(__FILE__), "..", "tmp")
  end

  def dummy_app
    [ "dummy_app", "production" ]
  end
end
