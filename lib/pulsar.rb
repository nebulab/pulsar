require 'pulsar/version'

module Pulsar
  require 'bundler'
  require 'thor'
  require 'rake'
  require 'interactor'
  require 'fileutils'

  require 'pulsar/interactors/cleanup'
  require 'pulsar/interactors/add_applications'
  require 'pulsar/interactors/clone_repository'
  require 'pulsar/interactors/copy_initial_repository'
  require 'pulsar/interactors/identify_repository_type'
  require 'pulsar/interactors/identify_repository_location'

  require 'pulsar/organizers/list'
  require 'pulsar/organizers/install'

  require 'pulsar/cli'
  require 'pulsar/constants'

  Rake::FileUtilsExt.verbose_flag = false # Silence Rake output
end
