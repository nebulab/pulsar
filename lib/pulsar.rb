require 'pulsar/version'

module Pulsar
  require 'bundler'
  require 'thor'
  require 'rake'
  require 'dotenv'
  require 'interactor'
  require 'fileutils'

  require 'pulsar/error_handler'
  require 'pulsar/interactors/cleanup'
  require 'pulsar/interactors/create_run_dirs'
  require 'pulsar/interactors/add_applications'
  require 'pulsar/interactors/clone_repository'
  require 'pulsar/interactors/copy_initial_repository'
  require 'pulsar/interactors/identify_repository_type'
  require 'pulsar/interactors/identify_repository_location'
  require 'pulsar/interactors/create_capfile'
  require 'pulsar/interactors/create_deploy_file'
  require 'pulsar/interactors/copy_environment_file'
  require 'pulsar/interactors/run_bundle_install'
  require 'pulsar/interactors/run_capistrano'

  require 'pulsar/organizers/list'
  require 'pulsar/organizers/install'
  require 'pulsar/organizers/deploy'

  require 'pulsar/constants'
  require 'pulsar/cli'

  # Silence Rake output
  Rake::FileUtilsExt.verbose_flag = false
end
