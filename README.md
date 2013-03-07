# Pulsar

[![Build Status](https://secure.travis-ci.org/nebulab/pulsar.png?branch=master)](http://travis-ci.org/nebulab/pulsar) 
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/nebulab/pulsar)

Pulsar is a little tool that helps with deploys a big number of applications. Its main purpose is building capfiles for
[Capistrano](https://rubygems.org/gems/capistrano) to run.

Since we usually manage a lot of projects each with its own very special configuration, we got tired of copying-and-pasting
Capistrano configurations around. A lot of people usually build a private gem with Capistrano reciepes in it but we 
wanted more.

Pulsar lets you keep all your configurations on a private repo (containing all your configurations/reciepes) for all your
servers and apps. As long as you have read access to the repo you'll be able, through pulsar, to build a custom dynamic 
Capfile on which Capistrano is executed.

These are some of the benefits of this approach:

* No need to pollute the apps with custom configurations
* No need to have the app locally to deploy your application
* It has multistage support by default
* Everything you add to your recipes can be easily shared with every other app
* Can easily be integrated with a web framework to provide easy 1-click deploys
* Everything is structured so that you write the least code possible to deploy apps
* You'll never have your eyes bleed on Capistrano output

Pulsar requires you, as a minimal configuration, to have the gem installed and store the configurations in a certain way
inside a local directory or git repo. Pulsar will then use that repo to build temporary Capfiles.

## Installation

For now pulsar lacks integration with other framworks. This means that the best way you can use it is standalone.
You can install it by running:

    $ gem install pulsar

## Usage

Pulsar currently supports two commands: `cap` and `list`.

### Cap command

The `cap` command is needed to (guess what) run Capistrano. The syntax will be a little different to that of Capistrano
since you're running it via `pulsar`.
For example, to see the list of tasks (like running `cap --tasks`) you have available you can run:

```
pulsar cap -c gh_user/pulsar-conf my_app production --tasks
```

That would result in pulsar fetching the `git@github.com:gh_user/pulsar-conf.git` repo (just the latest `HEAD` 
to preserve bandwidth) and building a Capfile on that looking for the configuration of `my_app` for stage `production`
and then running `cap --tasks` on that Capfile.

As you can guess, you can append any kind of args to this command and it will execute it as if your're running `cap`
inside your app.

For example to deploy a `my_app` in `production` you can run:

```
pulsar cap -c gh_user/pulsar-conf my_app production
```

by default pulsar will assume you want to run the `deploy` Capistrano task.

### List command

The `list` command will help you list the applications/environments you have configured. Running:

```
pulsar list -c gh_user/pulsar-conf
```

will output a list like this one:

```
my_app: production, staging
my_other_app: staging
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
