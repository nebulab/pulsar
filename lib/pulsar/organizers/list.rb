module Pulsar
  class List
    include Interactor::Organizer

    organize IdentifyRepositoryLocation, IdentifyRepositoryType,
             CloneRepository, AddApplications, Cleanup
  end
end
