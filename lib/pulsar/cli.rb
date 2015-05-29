module Pulsar
  class CLI < Thor
    desc 'install [DIRECTORY]', 'install initial repository in DIRECTORY'
    long_desc <<-LONGDESC
      `pulsar install` will install the initial pulsar repository in the
      current working directory.

      You can optionally specify a second parameter, which will be the
      destination directory in which to install the repository.
    LONGDESC
    def install(directory = './pulsar-conf')
      result = Pulsar::Install.call(directory: directory)

      if result.success?
        puts 'Successfully created intial repo!'
      else
        puts 'Failed to create intial repo.'
      end
    end

    desc 'list', 'list available applications and environments'
    long_desc <<-LONGDESC
      `pulsar list` will list the applications and environments available in
      the configured pulsar repository.
    LONGDESC
    option :conf_repo, required: true
    def list
      result = Pulsar::List.call(repository: options[:conf_repo])

      if result.success?
        puts result.applications
      else
        puts 'Failed to list application and stages.'
      end
    end
  end
end
