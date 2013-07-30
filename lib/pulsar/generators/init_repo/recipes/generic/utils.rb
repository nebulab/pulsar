namespace :utils do
  desc "Invoke your awesome rake tasks!"
  task :invoke_rake, :roles => :web do
    run("cd #{deploy_to}/current && RAILS_ENV=#{rails_env} #{rake} #{ENV['ARGS']}")
  end
end
