source 'http://rubygems.org'

gem 'rails', '3.2.11'
# gem 'activerecord-mysql2-adapter'
#gem "pg"
gem 'json', '1.8.3'
gem "haml-rails"
gem "kaminari"
gem 'kaminari-bootstrap', '~> 0.1.3'
gem "meta_search"
gem "devise", "2.0.0"
#gem "twitter", "2.5.0"
gem "cancan"
gem "fracture"
gem "mysql2"
gem 'honeybadger'
gem 'twitter', '~> 5.0'
gem 'whenever', :require => false

# JSruntime
# gem 'therubyracer', platforms: :ruby

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  # gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>=1.0.3'
end

gem 'jquery-rails'
gem 'nokogiri'

# Phantom JS headless browser scraping of angular sites
gem 'poltergeist'

#TODO moved to prod so seed.rb will work
gem "factory_girl_rails", "1.6.0"
gem "faker"

gem 'capistrano', '= 3.4.0'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rails', '~> 1.1.1'

# Add this if you're using rbenv
# gem 'capistrano-rbenv', github: "capistrano/rbenv"

# Add this if you're using rvm
gem 'capistrano-rvm', github: 'capistrano/rvm'

group :test, :development do
  #gem 'sqlite3'
  gem "rspec-rails", "~>2.8.0"
  gem "capybara", "1.1.2"
  #gem "cucumber-rails"
  gem "database_cleaner"
  gem "awesome_print"
  gem "shoulda-matchers"
end
