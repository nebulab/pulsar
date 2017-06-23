module Pulsar
  class Task
    include Interactor::Organizer

    organize IdentifyRepositoryLocation,
             IdentifyRepositoryType,
             CreateRunDirs,
             CloneRepository,
             AddApplications,
             CreateCapfile,
             CreateDeployFile,
             CopyEnvironmentFile,
             RunBundleInstall,
             RunCapistrano,
             Cleanup
  end
end
