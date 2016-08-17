set :stage, :production
set :rbenv_type, :system
set :rbenv_ruby, '2.2.5'
set :rails_env, :production

set :ssh_options, { forward_agent: true, port: 14014 }

server '37.139.29.122', user: 'deploy', roles: ['web', 'app', 'db']