# Pulsar

The easy [Capistrano](https://rubygems.org/gems/capistrano) deploy and configuration manager.

Pulsar allows you to run capistrano tasks via a separate repository where all your deploy configurations are stored.
Once you have your own repository, you can gradully add configurations and recipes so that you never have to duplicate code again.

The way Pulsar works means that you can deploy without actually having the application on your local machine (and neither
have all your application dependencies installed). This lets you integrate Pulsar with nearly any deploy strategy you can think of.

Some of the benefits of using Pulsar:
* No capistrano configurations in the application code
* No need to have the application locally to deploy
* Every recipe can be shared between all applications
* Can easily be integrated with other tools
* Write the least possible code to deploy

## Capistrano support

This version of Pulsar, version `1.0.0` only supports Capistrano v3. If you're looking for Capistrano v2 support you can
use Pulsar version `0.3.5` but, take care, that version is not maintained anymore.

## About

![Nebulab](http://nebulab.it/assets/images/public/logo.svg)

Cangaroo is funded and maintained by the [Nebulab](http://nebulab.it/) team.

We firmly believe in the power of open-source. [Contact us](http://nebulab.it/contact-us/) if you like our work and you need help with your project design or development.

[license]: MIT-LICENSE
