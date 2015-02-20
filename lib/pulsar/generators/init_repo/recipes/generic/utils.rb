namespace :utils do
  desc 'Invoke your awesome rake tasks!'
  task :invoke_rake, roles: :web do
    cd  = "cd #{deploy_to}/current"
    cmd = "RAILS_ENV=#{rails_env} #{rake} #{ENV['ARGS']}"

    run("#{cd} && #{cmd}")
  end
end
