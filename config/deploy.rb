require "bundler/capistrano"
#load 'lib/deploy/seed' #include if you need to load seed data with cap deploy:seed

set :stages, %w(develop production ci)
set :default_stage, "develop"
require 'capistrano/ext/multistage'
server "162.243.222.216", :app, :web, :db, :primary => true
set :user, "root" # The server's user for deploys
set :scm_passphrase, "emagxgestqkf" # The deploy user's password

set :application, "sean"

set :use_sudo, false

default_environment["GEM_PATH"] ="/usr/local/rvm/gems/ruby-2.0.0-p353"
default_environment["PATH"] = "$PATH"

set :deploy_via, :remote_cache

after "deploy", "deploy:cleanup" # keep only the last 5 releases
after "deploy:update_code", "deploy:migrate"
after "deploy:cleanup", "deploy:seed"

set :scm, "git"
set :scm_verbose, true
set :repository, "git@github.com:seanfreiburg/sean.git"


default_run_options[:pty] = true # Must be set for the password prompt from git to work
ssh_options[:forward_agent] = true

namespace :deploy do
# If you need to load seed data. Syntax: cap deploy:seed
  desc "Reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end

  task :start do ; end
  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}" #restarts nginx
  end
end

