server_address = '37.139.29.122'
set :application, 'mps'
set :repository, 'https://github.com/ivanovv/mps.git'
set :deploy_via, :remote_cache


set :user, 'deploy'
set :use_sudo, false
set (:deploy_to) { "/home/#{user}/apps/#{application}" }

set :scm, :git
set :ssh_options, { :forward_agent => true }

server server_address, :app, :web, :db, :primary => true

require 'bundler/capistrano'
set :bundle_flags, '--deployment --quiet --binstubs'

set :default_environment, {
    'PATH' => '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'
}

require 'thinking_sphinx/capistrano'
after 'deploy:update_code', :copy_database_config
after 'deploy:finalize_update', :symlink_nginx_config
after 'deploy', 'deploy:cleanup'


task :symlink_nginx_config, roles: :app do
  run "sudo ln -nfs #{release_path}/config/mps.nginx /etc/nginx/sites-enabled/mps"
end

task :copy_database_config, roles => :app do
  db_config = "#{shared_path}/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
end

set (:unicorn_conf) {"#{deploy_to}/current/config/unicorn.rb"}
set (:unicorn_pid) {"#{shared_path}/pids/unicorn.pid"}
set (:unicorn_start_cmd) {"(cd #{deploy_to}/current; bundle exec unicorn_rails -Dc #{unicorn_conf} -E production)"}

set :bundle_cmd, 'bundle'


# - for unicorn - #
namespace :deploy do
  desc 'Start application'
  task :start, :roles => :app do
    run unicorn_start_cmd
  end

  desc 'Stop application'
  task :stop, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end

  desc 'Restart Application'
  task :restart, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || #{unicorn_start_cmd}"
  end
end
