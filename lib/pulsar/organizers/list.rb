module Pulsar
  class List
    include Interactor::Organizer

    organize IdentifyRepositoryType, CloneRepository, AddApplications, Cleanup
  end
end
