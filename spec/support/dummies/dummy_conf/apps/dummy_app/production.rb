# This is apps/dummy_app/production.rb

server 'dummy.it', :db, :web, :app, primary: true

set :stage, 'production'
