# This is apps/dummy_app/staging.rb

server 'staging.dummy.it', :db, :web, :app, primary: true

set :stage, 'staging'
