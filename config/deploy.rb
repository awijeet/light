set :application, "rubyonrails4ror"
set :repository,  "git@github.com:awijeet/light.git"
set :scm, :git
set :branch, 'master'
set :user, "root"
set :use_sudo, false
set :deploy_via, :copy
set :deploy_to, "/var/apps/#{application}"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
#/var/apps/rubyonrails4ror/current/public
role :web, "208.111.45.210"                          # Your HTTP server, Apache/etc
role :app, "208.111.45.210"                          # This may be the same as your `Web` server
role :db,  "208.111.45.210", :primary => true # This is where Rails migrations will run
role :db,  "208.111.45.210"

# if you want to clean up old releases on each deploy uncomment this:
 after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end
