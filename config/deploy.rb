set :application, 'mps'
set :scm, :git
set :repo_url, 'https://github.com/ivanovv/mps.git'
set :log_level, :info


set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :unicorn_config_path, 'config/unicorn.rb'
set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"

# set :use_sudo, false
set :deploy_to, '/home/deploy/apps/mps'

set :bundle_jobs, 4
set :bundle_binstubs, nil
set :pty,  false

set :assets_roles, [:web, :app]

namespace :deploy do

  namespace :nginx do
    desc 'Reload nginx configuration'
    task :reload do
      on roles [:web] do
        execute 'sudo service nginx reload'
      end
    end

    desc 'Symlink Nginx config (requires sudo)'
    task :symlink_config do
      on roles [:web] do
        within release_path do
          sudo :cp, '-f', "config/nginx.#{fetch(:stage)}.conf", '/etc/nginx/nginx.conf'
        end
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      execute :sudo, 'service unicorn upgrade'
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      if test "[ -f #{fetch(:unicorn_pid)} ]"
        execute :kill, "-s QUIT `cat #{fetch(:unicorn_pid)}`"
      end
    end
  end

  after :finishing, :cleanup
end


after 'deploy:updated', 'deploy:nginx:symlink_config'
after 'deploy:updated', 'deploy:nginx:reload'
after 'deploy:publishing', 'deploy:restart'
