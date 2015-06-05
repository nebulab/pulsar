module Pulsar
  class Install
    include Interactor::Organizer

    organize CloneInitialRepository
  end
end
