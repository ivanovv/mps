server_address = 'ec2-54-217-232-182.eu-west-1.compute.amazonaws.com'
set :application, 'mps'
set :repository, 'https://github.com/ivanovv/mps.git'
set :deploy_via, :remote_cache


set :user, 'deploy'
set :use_sudo, false
set (:deploy_to) { '/home/deploy/code/mps' }

set :scm, :git
set :ssh_options, { :forward_agent => true }

role :web, server_address # Your HTTP server, Apache/etc
role :app, server_address # This may be the same as your `Web` server
role :db, server_address, :primary => true        # This is where Rails migrations will run

require 'bundler/capistrano'
require 'rvm/capistrano'

set :rvm_type, :system
set :rvm_ruby_string, '2.0.0-p195'


#require 'thinking_sphinx/deploy/capistrano'


after 'deploy:update_code', :copy_database_config

task :copy_database_config, roles => :app do
  db_config = "#{shared_path}/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
end

set (:unicorn_conf) {"#{deploy_to}/current/config/unicorn.rb"}
set (:unicorn_pid) {"#{shared_path}/pids/unicorn.pid"}
set (:unicorn_start_cmd) {"(cd #{deploy_to}/current; bundle exec unicorn_rails -Dc #{unicorn_conf})"}

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
