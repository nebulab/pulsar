namespace :rake do
  desc "Invoke your awesome rake tasks!"
  task :invoke, :roles => :web do
    run("cd #{deploy_to}/current && RAILS_ENV=#{rails_env} bundle exec rake #{ENV['ARGS']}")
  end
end
