# This is apps/other_dummy_app/production.rb

server "other_dummy.it", :db, :web, :app, :primary => true

set :stage, "production"
