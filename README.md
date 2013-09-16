# Pulsar [![Gem Version](https://badge.fury.io/rb/pulsar.png)](http://badge.fury.io/rb/pulsar) [![Build Status](https://secure.travis-ci.org/nebulab/pulsar.png?branch=master)](http://travis-ci.org/nebulab/pulsar) [![Coverage Status](https://coveralls.io/repos/nebulab/pulsar/badge.png?branch=master)](https://coveralls.io/r/nebulab/pulsar) [![Code Climate](https://codeclimate.com/github/nebulab/pulsar.png)](https://codeclimate.com/github/nebulab/pulsar)

The easy [Capistrano](https://rubygems.org/gems/capistrano) deploy and configuration manager.

Pulsar allows you to run capistrano tasks via a separate repository where all your deploy configurations are stored.
Once you have your own repository, you can gradully add configurations and recipes so that you never have to duplicate code again.

The way Pulsar works means that you can deploy without actually having the application on your local machine (and neither
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
$ gem install pulsar
```

This will install two commands: `pulsar` and `pulsar-utils`. The first command is required to run capistrano,
the other is for everything else.

---

You'll need to create your own configuration repo:

```bash
$ pulsar-utils init ~/Desktop/pulsar-conf
```

This will create a basic start point for building your configuration repository. As soon as you're done configuring
you should consider storing this folder as an actual git repository.

Here it is possible to see how this configuration repository will look like: [Pulsar Conf Demo](http://github.com/nebulab/pulsar-conf-demo)

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
      │   └── utils.rb
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

### _apps_ directory

This directory contains your application configurations. You'll have one directory per application.

* `base.rb` has configurations that are shared by all applications
* `my_application/defaults.rb` includes configuration shared by every stage of the application
* `my_application/staging.rb` and `my_application/production.rb` files include stage configurations
* `my_application/recipes/` are recipes that are always included for that application (no need to use `load_recipes`)

### _recipes_ directory

This directory contains your recipes. You can create any number of directories to organize your recipes.
To load a recipe from your configurations you can use the `load_recipes` helper:

```ruby
#
# Somewhere inside apps/
#
load_recipes do
  rails :repair_permissions, :unicorn
  generic :cleanup, :utils
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

---

You can specify some recipes to be loaded only when you run Pulsar from inside a Rack application directory.
This is useful with recipes that require something inside that directory (like retrieving the database/assets
from a staging environment).

You can do that like this:

```ruby
#
# Somewhere inside apps/
#

#
# These recipes will be available only if you're running
# Pulsar inside a Rack application (like Rails) directory
#
load_recipes(app_only: true) do
  rails :assets_pull, :database_pull
end
```

### Loading the repository

Once the repository is ready, you'll need to tell Pulsar where it is. The repository location can be specified either
as a full git path or a github repository path (`gh-user/pulsar-conf`).

Since Pulsar requires the repository for everything, there are multiple ways to store this information so that
you don't have to type it everytime. You can also use local repository, which is useful while developing your
deployment.

You have three possibilities:

* `-c` command line option
* `PULSAR_CONF_REPO` environment variable
* `~/.pulsar` configuration file

The fastest way is probably the `.pulsar` hidden file inside your home directory:

```bash
#
# Inside ~/.pulsar
#
PULSAR_CONF_REPO="gh-user/pulsar-conf"

#
# You can use local repository for development so you don't need to push changes every time
#
# PULSAR_CONF_REPO="/full/path/to/repository"

#
# Also supported
#
# PULSAR_CONF_REPO="git://github.com/gh-user/pulsar-conf.git"
```

Pulsar will read this file and set the environment variables properly.

---

If you don't want to add another file to your home directory you can export the variables yourself:

```bash
#
# Inside ~/.bash_profile or ~/.zshrc
#
export PULSAR_CONF_REPO="gh-user/pulsar-conf"
```

## Usage

After the repository is ready, running Pulsar is straightforward. To deploy `my_application` to `production`:

```bash
$ pulsar my_application production
```

As a rule of thumb, anything that's added at the end of the command is passed to capistrano. Some examples:

```bash
$ pulsar my_application production --tasks

$ pulsar my_application staging deploy:migrations

$ pulsar my_application staging shell

#
# Deploy multiple apps by using commas
#
$ pulsar my_app1,my_app2,my_app3 production

#
# Deploy multiple apps by using pattern matching
# (uses Dir.glob)
#
$ pulsar my_app* production
# or
$ pulsar *worker staging

```

### Running inside a Rack application (e.g. Ruby on Rails application)

In case you frequently work from a Rack application and would like a workflow similar to that of capistrano, Pulsar
supports running from inside a Rack application directory. If you use this a lot, you should consider installing
Pulsar via the application `Gemfile`.

When deploying from inside a Rack application you can omit the application name:

```bash
$ cd /path/to/my_application

$ pulsar production

$ pulsar staging deploy:migrations
```

---

If you need a particular configuration for an application you can store a `.pulsar` file inside the application
directory:

```bash
#
# Inside /path/to/my_application/.pulsar
#
PULSAR_CONF_REPO="gh-user/pulsar-conf"

#
# If the application directory name is different than what
# you configured inside the Pulsar configuration repository
#
# PULSAR_APP_NAME="my-application"
```

## Integrations

Pulsar is easy to integrate, you just need access to the configurations repository and the ability to
run a command.

### Hubot

https://gist.github.com/mtylty/5324075

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes with tests (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
