# Production config

server 'blog.com', user: 'deploy', roles: %w{web app db}, primary: true
set :stage, :production
