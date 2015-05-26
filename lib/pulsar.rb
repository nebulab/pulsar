require 'pulsar/version'

module Pulsar
  require 'bundler'
  require 'thor'
  require 'interactor'
  require 'fileutils'

  require 'pulsar/interactors/install'
  require 'pulsar/cli'
end
