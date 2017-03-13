module Pulsar
  class Deploy
    include Interactor::Organizer

    organize IdentifyRepositoryLocation, IdentifyRepositoryType,
             CloneRepository, CreateCapfile, Cleanup
  end
end
