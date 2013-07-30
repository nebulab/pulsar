#
# Require everything and extend with additional modules
#
Bundler.require

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
  generic :cleanup, :utils
end

#
# Put here shared configuration that should be a default
# for all your apps
#

# set :scm, :git
# set :repository, defer { "git@github.com:your_gh_user/#{application}.git" }
# set :branch, "master"
# set :port, 22
# set :ssh_options, { :forward_agent => true }
# set :default_run_options, { :pty => true }
# set :deploy_to, defer { "/var/www/#{application}" }
# set :deploy_via, :remote_cache
# set :user, "www-data"
# set :use_sudo, false
# set :rake, "bundle exec rake"
# set :rails_env, defer { "#{stage}" }
