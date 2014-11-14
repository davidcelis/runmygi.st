# config valid only for Capistrano 3.2
lock '3.2.1'

set :application, 'runmygi.st'
set :repo_url, 'git@github.com:davidcelis/runmygi.st.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/david/runmygi.st'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/usr/local/bin/:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Set the Ruby that chruby will use
set :chruby_ruby, 'ruby-2.1.5'

namespace :deploy do
  desc 'Start application'
  task :start do
    invoke 'puma:start'
  end

  desc 'Stop application'
  task :stop do
    invoke 'puma:stop'
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
