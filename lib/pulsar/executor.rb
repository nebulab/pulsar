require 'open3'

module Pulsar
  module Executor
    def self.sh(cmd)
      stdin_stream, stdout_stream, stderr_stream, wait_thr = Open3.popen3(cmd)
      stdout = stdout_stream.gets(nil) || ""
      stderr = stderr_stream.gets(nil) || ""
      stdout_stream.close
      stderr_stream.gets(nil)
      stderr_stream.close
      stdin_stream.close
      exit_code = wait_thr.value
      yield exit_code, stdout, stderr if block_given?
      { status: exit_code.exitstatus, output: stdout + stderr }
    end
  end
end
