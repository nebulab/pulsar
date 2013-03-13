server "staging.your_app.com", :db, :web, :app, :primary => true

set :stage, "staging"

load_recipes do
  #
  # Recipes you wish to include for staging stage only
  # for example:
  #
  # server :passenger
  # notify :campfire
end
