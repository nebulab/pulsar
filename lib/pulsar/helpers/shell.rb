require 'fileutils'

module Pulsar
  module Helpers
    module Shell
      include FileUtils

      def cd(path, opts)
        puts "Directory: #{path.white}".yellow if opts[:verbose]
        FileUtils.cd(path) { yield }
      end

      def rm_rf(path, opts)
        puts "Remove: #{path.white}".yellow if opts[:verbose]
        FileUtils.rm_rf(path)
      end

      def run_cmd(cmd, opts)
        puts "Command: #{cmd.white}".yellow if opts[:verbose]
        system(cmd)

        fail "Command #{cmd} Failed" if $? != 0
      end

      def touch(file, opts)
        puts "Touch: #{file.white}".yellow if opts[:verbose]
        FileUtils.touch(file)
      end
    end
  end
end
