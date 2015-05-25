module Pulsar
  class CLI < Thor
    desc 'install [DIRECTORY]', 'install initial repository in DIRECTORY'
    long_desc <<-LONGDESC
      `pulsar install` will install the initial pulsar repository in the
      current working directory.

      You can optionally specify a second parameter, which will be the
      destination directory in which to install the repository.
    LONGDESC
    def install(directory = '.')
      Install.call(directory: directory)
    end
  end
end
