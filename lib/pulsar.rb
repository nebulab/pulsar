require 'pulsar/version'

module Pulsar
  require 'bundler'
  require 'thor'
  require 'interactor'
  require 'fileutils'

  require 'pulsar/interactors/add_applications'
  require 'pulsar/interactors/clone_initial_repository'

  require 'pulsar/organizers/list'
  require 'pulsar/organizers/install'

  require 'pulsar/cli'
end
