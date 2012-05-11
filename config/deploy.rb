require "rvm/capistrano"
require 'bundler/capistrano'
load 'deploy/assets'
set :rvm_ruby_string, '1.9.2'
set :rvm_type, :user  # Don't use system-wide RVM
set :bundle_flags, ""
set :bundle_dir, ""

set :user, "root"
set :use_sudo, false

set :application, "rubyonrails4ror"
set :repository,  "git@github.com:awijeet/light.git"
set :scm, :git
set :branch, 'master'
set :deploy_to, "/var/apps/#{application}"

role :web, "208.111.45.210"                          # Your HTTP server, Apache/etc
role :app, "208.111.45.210"                          # This may be the same as your `Web` server
role :db,  "208.111.45.210", primary: true # This is where Rails migrations will run

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, roles: :app, except: { no_release: true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
