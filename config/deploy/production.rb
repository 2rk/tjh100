set :rails_env, 'production'

set :rvm_ruby_string, "2.1.5"
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

set :rvm_install_ruby_params, '--verify-downloads 1'
set :ssl, false
set :branch, 'master'

#default_run_option[:pty] = true
ssh_options[:forward_agent] = true


# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`


server 'eserver1.tworedkites.com', :web, :app, :db, primary: true

# set :hostnames, "shop.lifecellaustralia.com.au"
# set :redirect_hostnames, ["shop.lifecellaustralia.com"]

# before 'deploy:setup', 'rvm:install_rvm' # update RVM
before 'deploy:setup', 'rvm:install_ruby'

after 'deploy:update_code' do
  run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
end