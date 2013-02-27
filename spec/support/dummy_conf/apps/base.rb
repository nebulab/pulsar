#
# Require and extend with additional modules
#
require 'pulsar'

extend Pulsar::Helpers::Capistrano

#
# Load deploy capistrano recipe
#
load 'deploy'

#
# Configure libraries/recipes from Gemfile
#
require 'bundler/capistrano'

#
# Load default recipes
#
load_recipes do
  generic :notify, :cleanup, :rake
end

#
# Put here shared configuration that should be by default
#
set :scm, :git

set :ssh_options, { :forward_agent => true }

set :default_run_options, { :pty => true }

set :deploy_to, defer { "/var/www/#{application}" }

set :deploy_via, :remote_cache

set :user, "www-data"

set :use_sudo, false

set :rake, "bundle exec rake"

set :rails_env, defer { "#{stage}" }
