# This is apps/other_dummy_app/custom_stage.rb

server 'dummy.it', :db, :web, :app, primary: true

set :stage, 'custom_stage'
