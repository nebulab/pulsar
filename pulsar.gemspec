# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pulsar/version'

Gem::Specification.new do |gem|
  gem.name           = "pulsar"
  gem.version        = Pulsar::VERSION
  gem.authors        = ["Alberto Vena", "Matteo Latini"]
  gem.email          = ["info@nebulab.it"]
  gem.description    = %q{NebuLab's central capistrano deploy resource.}
  gem.summary        = %q{
    A simple gem that parses capistrano configuration froma another (private) repository
    providing a simple solution to managing multiple systems without installing capistrano
    configurations in each app.
  }
  gem.homepage       = "https://github.com/nebulab/pulsar"

  gem.files          = `git ls-files`.split($/)
  gem.executables    = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files     = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths  = ["lib"]

  gem.add_dependency "clamp", "~> 0.5"
  gem.add_dependency "bundler", "~> 1.2"
end
