module Pulsar
  class Install
    include Interactor::Organizer

    organize CopyInitialRepository
  end
end
