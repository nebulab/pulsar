require 'spec_helper'

describe Pulsar::CapCommand do
  let(:pulsar) { Pulsar::CapCommand.new("cap") }

  it "builds a Capfile file in tmp dir" do
    expect { pulsar.run(full_cap_args + dummy_app) }.to change{ Dir.glob("#{tmp_path}/capfile-*").length }.by(1)
  end

  it "copies a the repo over to temp directory" do
    expect { pulsar.run(full_cap_args + %w(--keep-repo) + dummy_app) }.to change{ Dir.glob("#{tmp_path}/conf-repo*").length }.by(1)
  end

  it "copies a the repo when there is a dir with same name" do
    system("mkdir #{tmp_path}/conf-repo")
    expect { pulsar.run(full_cap_args + %w(--keep-repo) + dummy_app) }.to change{ Dir.glob("#{tmp_path}/conf-repo*").length }.by(1)
  end

  context "--conf-repo option" do
    it "is required" do
      expect { pulsar.parse([""]) }.to raise_error(Clamp::UsageError)
    end

    it "supports directories" do
      expect { pulsar.run(full_cap_args + dummy_app) }.not_to raise_error(Errno::ENOENT)
    end
  end

  context "--tmp-dir option" do
    it "is supported" do
      expect { pulsar.parse(base_args + %w(--tmp-dir dummy_tmp) + dummy_app) }.to_not raise_error(Clamp::UsageError)
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

      latest_capfile.should match(/logger.level = logger.level = Capistrano::Logger::IMPORTANT/)
    end

    it "supports Capistrano INFO" do
      pulsar.run(full_cap_args + %w(--log-level info) + dummy_app)

      latest_capfile.should match(/logger.level = logger.level = Capistrano::Logger::INFO/)
    end

    it "supports Capistrano DEBUG" do
      pulsar.run(full_cap_args + %w(--log-level debug) + dummy_app)

      latest_capfile.should match(/logger.level = logger.level = Capistrano::Logger::DEBUG/)
    end
  end
end
