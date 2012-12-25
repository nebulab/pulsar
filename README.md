# Pulsar

NebuLab's central capistrano deploy resource.


A quick example. To run any cap command for an application specified in a configuration repo you can run:

```
deploy -c=<configuration-repo-git-url> <application> <stage> <capistrano_args>
```

A couple of concrete examples:

```
pulsar -c git@github.com:nebulab/deploy-configuration.git nebulab production --tasks

pulsar -c git@github.com:nebulab/deploy-configuration.git nebulab staging # Deploy on staging

pulsar -c git@github.com:nebulab/deploy-configuration.git farmavillage production deploy:check
```

## Installation

Add this line to your application's Gemfile:

    gem 'pulsar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pulsar

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
