lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pulsar/version'

Gem::Specification.new do |gem|
  gem.name           = 'pulsar'
  gem.version        = Pulsar::VERSION
  gem.authors        = ['Matteo Latini']
  gem.email          = ['matteolatini@nebulab.it']
  gem.homepage       = 'http://pulsar.nebulab.it'
  gem.description    = 'Manage your Capistrano deployments with ease'
  gem.summary        = '
    Pulsar helps with Capistrano configuration management. It uses a repository
    to store all your precious configurations and recipes to build Capistrano
    deploys on it.
  '

  gem.files          = `git ls-files`.split($/)
  gem.bindir         = 'exe'
  gem.executables    = gem.files.grep(%r{^exe\/}).map { |f| File.basename(f) }
  gem.test_files     = gem.files.grep(%r{^(test|spec|features)\/})
  gem.require_paths  = ['lib']

  gem.add_dependency 'bundler', '~> 1.8'
  gem.add_dependency 'thor', '~> 0.19'
  gem.add_dependency 'interactor', '~> 3.1'
  gem.add_dependency 'dotenv', '~> 2.0'

  gem.add_development_dependency 'rake', '~> 10.4'
  gem.add_development_dependency 'rspec', '~> 3.2'
  gem.add_development_dependency 'rubocop', '~> 0.47'
  gem.add_development_dependency 'timecop', '~> 0.8'
  gem.add_development_dependency 'simplecov', '~> 0.14.0'
  gem.add_development_dependency 'coveralls', '~> 0.8.20'
end
