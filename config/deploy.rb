require 'bundler/capistrano'
require 'rvm/capistrano'
require 'capistrano/ext/multistage'
# require "dotenv/capistrano"
# require 'airbrake/capistrano'
# require 'whenever/capistrano'
# require 'hipchat/capistrano2'
require 'active_support/core_ext'

set :application, 'tjh100'
set :stages, %w(integ, uat, production)
set :default_stage, "integ"
set :user, 'tjh100'
set :repository, 'git@github.com:2rk/tjh100.git'
set (:deploy_to) { "/home/#{user}/apps/#{rails_env}" }
set :deploy_via, :remote_cache
set :use_sudo, false
set :scm, 'git'
set :rails_env, 'production'
set :ssl, false

# set :whenever_command, "bundle exec whenever"
# set :whenever_environment, defer { stage }
# set :whenever_variables, defer { "'environment=#{rails_env}&log_path=#{shared_path}'" }
# set :whenever_identifier, defer { "#{application}_#{stage}" }

set :rvm_ruby_string, File.read(".ruby-version").chomp
set :rvm_type, :system
set :rvm_path, "/usr/local/rvm"

set :mysql_password, YAML::load_file("config/database.yml.server")["production"]["password"]

set :bundle_flags, "--deployment"

# ## WHENEVER
#
# set :whenever_variables, defer { "'environment=#{rails_env}&log_path=#{shared_path}'" }
# set :whenever_identifier, defer { "#{application}_#{stage}" }
# set :whenever_command, "bin/whenever"

## HIPCHAT

# set :hipchat_token, "87be7baf67c409971be15f7b5edcda"
# set :hipchat_room_name, [ user, "GitHub"]

namespace :deploy do


  # task :airbrake_test do
  #   run "cd #{current_path}; RAILS_ENV=#{stage} bin/rake airbrake:test; true"
  # end

  desc "Symlink shared configs and folders on each release."

  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/products #{release_path}/public/spree/products"
  end

  after 'deploy:update_code', 'deploy:symlink_shared'

  task :create_shared_database_config do
    run "mkdir -p #{shared_path}/config"
    top.upload File.expand_path('../database.yml.server', __FILE__), "#{shared_path}/config/database.yml"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :github_ssh_key do
    run "ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ''; ssh -oStrictHostKeyChecking=no git@github.com; cat .ssh/id_rsa.pub"
  end

  task :nginx_conf do
    set :nginx_conf_file, "/opt/nginx/conf/servers/#{application}_#{stage}.conf"

    ssl_conf = <<ssl_conf
  ssl on;
  ssl_certificate #{ssl_certificates_path}/#{ssl_certificates_name}.crt;
  ssl_certificate_key #{ssl_certificates_path}/#{ssl_certificates_name}.key;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

  passenger_set_cgi_param HTTPS on;
  passenger_set_cgi_param SSL_CLIENT_S_DN $ssl_client_s_dn;
  passenger_set_cgi_param SSL_CLIENT_VERIFY $ssl_client_verify;

  passenger_set_cgi_param HTTP_X_FORWARDED_PROTO https;
}

server {
  listen      443;
  server_name #{redirect_hostnames.join(' ')};
  return      301  https://#{hostnames}$request_uri;
  ssl_certificate #{ssl_certificates_path}/#{redirect_ssl_certificates_name}.crt;
  ssl_certificate_key #{ssl_certificates_path}/#{redirect_ssl_certificates_name}.key;
}

server {
  listen      80;
  server_name #{redirect_hostnames.join(' ')};
  return      301  https://#{hostnames}$request_uri;
}

server {
  listen      80;
  server_name #{hostnames};
  return      301  https://#{hostnames}$request_uri;
ssl_conf

    conf = <<conf
server {
  listen #{ssl ? 443 : 80};
  server_name #{user}.#{stage}.tworedkites.com #{hostnames};
  root /home/#{user}/apps/#{stage}/current/public;
  passenger_enabled on;
  passenger_ruby /usr/local/rvm/bin/#{application}_ruby;
  rack_env production;
  client_max_body_size 10m;

#{ssl_conf}
}
conf

    put(conf, nginx_conf_file)

    run "sudo service nginx reload"
  end

  task :rvm_wrapper do
    run "rvm wrapper #{rvm_ruby_string} #{application}"
  end

  before 'deploy:rvm_wrapper', 'rvm:install_ruby'

  task :create_database do
    set :mysql_pass_arg, mysql_password.blank? ? '' : "-p#{mysql_password}"
    run "mysql --user=root #{mysql_pass_arg} -e \"CREATE DATABASE IF NOT EXISTS #{application}_#{stage}\""
  end

end

namespace :rake do
  desc "Run a task on a remote server."
  # run like: cap staging rake:invoke task=a_certain_task
  task :invoke do
    run("cd #{deploy_to}/current; /usr/bin/env rake #{ENV['task']} RAILS_ENV=#{rails_env}")
  end
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
end

# after 'deploy:update_code', 'deploy:precompile_assets'
after 'deploy:setup', 'deploy:create_database', 'deploy:github_ssh_key', 'deploy:nginx_conf', 'deploy:rvm_wrapper'
before 'deploy:cold', 'deploy:create_shared_database_config' #,'deploy:symlink'
#after 'deploy:cold', 'deploy:airbrake_test'



### EXTRAS

namespace :product_images do
  desc "Creates product_images folders unless they exist"
  task :setup, except: { no_release: true } do
    dirs = image_dirs.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
  end

  desc "[internal] Creates the symlink to logos shared folder, for the most recently deployed version."
  task :symlink, :except => { :no_release => true } do
    run "rm -rf #{release_path}/public/spree/products"
    run "ln -nfs #{shared_path}/spree/products #{release_path}/public/spree/products"
  end

  desc "[internal] Computes logos directory paths, and registers them in Capistrano environment."
  task :register_dirs do
    set :image_dirs,    %w(spree/products)
    set :shared_children, fetch(:shared_children) + fetch(:image_dirs)
  end

  after       "deploy:finalize_update", "product_images:symlink"
  on :start,  "product_images:register_dirs"
end