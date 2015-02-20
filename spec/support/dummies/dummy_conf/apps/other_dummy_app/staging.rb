# This is apps/other_dummy_app/staging.rb

server 'staging.other_dummy.it', :db, :web, :app, primary: true

set :stage, 'staging'
