# Staging config

server 'staging.blog.com', user: 'deploy', roles: %w{web app db}, primary: true
set :stage, :staging
