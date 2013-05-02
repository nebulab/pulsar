# Pulsar [![Gem Version](https://badge.fury.io/rb/pulsar.png)](http://badge.fury.io/rb/pulsar) [![Build Status](https://secure.travis-ci.org/nebulab/pulsar.png?branch=master)](http://travis-ci.org/nebulab/pulsar) [![Coverage Status](https://coveralls.io/repos/nebulab/pulsar/badge.png?branch=master)](https://coveralls.io/r/nebulab/pulsar) [![Code Climate](https://codeclimate.com/github/nebulab/pulsar.png)](https://codeclimate.com/github/nebulab/pulsar)

The easy [Capistrano](https://rubygems.org/gems/capistrano) deploy and configuration manager.

Pulsar allows you to run capistrano tasks via a separate repository where all your deploy configurations are stored.
Once you have your own repository, you can gradully add configurations and recipes so that you never have to duplicate code again.

The way Pulsar works also mean that you can deploy without actually having the application on your local machine (and neither
have all your application dependencies installed). This lets you integrate Pulsar with nearly any deploy strategy you can think of.

Some of the benefits of using Pulsar:
* No capistrano configurations in the application code
* No need to have the application locally to deploy
* Multistage support by default
* Every recipe can be shared between all applications
* Can easily be integrated with other tools
* Write the least possible code to deploy

## Installation

The most useful way of installing Pulsar is as a system gem:

```bash
gem install pulsar
```

This will install two commands: `pulsar` and `pulsar-utils`. The first command is required to run capistrano,
the other is for everything else.

---

You'll need to create your own configuration repo:

```bash
pulsar-utils init ~/Desktop/pulsar-conf
```

This will create a basic start point for building your configuration repository. As soon as you're done configuring
you should consider storing this folder as an actual git repository.

**NOTE**: Pulsar only supports git and *nix systems.

## Configuration

This is an example repository configuration layout:

```bash
pulsar-conf/
  |── Gemfile
  ├── Gemfile.lock
  ├── apps
  │   ├── base.rb
  │   └── my_application
  │       ├── defaults.rb
  │       ├── production.rb
  │       ├── recipes
  │       │   └── custom_recipe.rb
  │       └── staging.rb
  └── recipes
      ├── generic
      │   ├── cleanup.rb
      │   ├── maintenance_mode.rb
      │   ├── notify.rb
      │   └── rake.rb
      ├── rails
      │   ├── passenger.rb
      │   ├── repair_permissions.rb
      │   ├── symlink_configs.rb
      │   ├── unicorn.rb
      │   └── whenever.rb
      └── spree_1
          └── symlink_assets.rb
```

Pulsar uses these files to build capistrano configurations on the fly, depending on how you invoke the `pulsar` command.
Since Pulsar it's basically a capistrano wrapper, the content of these files is plain old capistrano syntax.

### `apps` directory

This directory contains your application configurations. You'll have one directory per application.

* `base.rb` has configurations that are shared by all applications
* `my_application/defaults.rb` includes configuration shared by every application stage
* `my_application/staging.rb` and `my_application/production.rb` files include stage configurations
* `my_application/recipes/` are recipes automatically included for that application

### `recipes` directory

This directory contains your recipes. You can create any number of directories to organize your recipes.
To load a recipe from your configurations you can use the `load_recipes` helper:

```ruby
#
# Somewhere inside apps/
#
load_recipes do
  rails :repair_permissions, :unicorn
  generic :cleanup, :rake
end
```

This will use capistrano's `load` method to include recipes from `rails/` and `generic/`.

---

Another way to include your recipes is by using the `Gemfile`. Many gems already include custom recipes for capistrano so
you just need to require those. An example with [Whenever](https://github.com/javan/whenever):

```ruby
#
# Inside Gemfile
#
gem 'whenever'

#
# Inside recipes/rails/whenever.rb
#
require 'whenever/capistrano'

set :whenever_command, "bundle exec whenever"

#
# Somewhere inside apps/
#
load_recipes do
  rails :whenever
end
```

## Usage

blabla

## Integrations

blabla

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes with tests (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
