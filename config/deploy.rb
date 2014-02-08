require 'rvm/capistrano'
require 'bundler/capistrano'

set :application, "Todo Application"
set :repository,  "git@github.com:mrkjlchvz/todoapp.git"

set :scm, :git
set :branch, "master"
set :user, "ubuntu"
set :group, "deployers"
set :deploy_to, "/home/ubuntu/nginx"

set :use_sudo, false
set :rails_env, "production"

set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }
set :keep_releases, 5

ssh_options[:keys] = ["/Users/mark/.ssh/mark-macosx.pem"]
default_run_options[:pty] = true

server "54.213.82.201", :app, :web, :db, :primary => true

after "deploy", "deploy:symlink_config_files"
after "deploy", "deploy:restart"
after "deploy", "deploy:cleanup"

namespace :deploy do
  desc "Symlink shared config files"
  task :symlink_config_files do
    run "#{sudo} ln -sf #{deploy_to}/shared/config/database.yml #{latest_release}/config/database.yml"
  end

  desc "Restart passenger"
  task :restart do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
