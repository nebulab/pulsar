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
