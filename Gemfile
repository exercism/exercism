source 'https://rubygems.org'

ruby '2.3.3'

gem 'activesupport', '~> 4.2.1'
gem 'activerecord', '~> 4.2.1'

gem 'bugsnag'
gem 'faraday'
gem 'loofah'
gem 'petroglyph'
gem 'pg'
gem 'pry', require: false
gem 'puma', '~> 2.15.0'
gem 'rack-flash3', require: 'rack-flash'
gem 'rake', '~> 10.5.0'
gem 'redcarpet', '~> 3.1'
gem 'rouge', '~> 2.0.5'
gem 'sinatra', '~> 1.4.7', require: 'sinatra/base'
gem 'sinatra-contrib', '~> 1.4.7'
gem 'sidekiq'
gem 'trackler', '~> 2.0.0'
gem 'will_paginate'
gem 'will_paginate-bootstrap'

# Frontend Gems
gem 'sass'
gem 'compass'
gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'kss'

group :test, :development do
  gem 'approvals', require: false
  gem 'coveralls', require: false
  gem 'database_cleaner', require: false
  gem 'dotenv', require: false
  gem 'foreman', require: false
  gem 'mocha', require: false
  gem 'rack-test', require: false
  gem 'simplecov', require: false
  gem 'sqlite3'
  gem 'timecop', require: false
  gem 'rb-readline'
end

group :development do
  gem 'rubocop', '0.36.0', require: false
end

group :test do
  gem 'launchy'
  gem 'minitest-capybara'
end
