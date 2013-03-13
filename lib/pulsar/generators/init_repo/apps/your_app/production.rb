server "your_app.com", :db, :web, :app, :primary => true

set :stage, "production"

load_recipes do
  #
  # Recipes you wish to include for production stage only
  # for example:
  #
  # rails :fix_permissions, :symlink_db
  # server :unicorn
end
