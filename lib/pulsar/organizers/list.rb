module Pulsar
  class List
    include Interactor::Organizer

    organize IdentifyRepositoryType, CloneRepository, AddApplications
  end
end
