module Pulsar
  class List
    include Interactor::Organizer

    organize IdentifyRepositoryLocation, IdentifyRepositoryType,
             CreateRunDirs, CloneRepository, AddApplications, Cleanup
  end
end
