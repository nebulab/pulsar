module Pulsar
  class Deploy
    include Interactor::Organizer

    organize IdentifyRepositoryLocation, IdentifyRepositoryType,
             CreateRunDirs, CloneRepository, CreateCapfile, Cleanup
  end
end
