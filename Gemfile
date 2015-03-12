source "http://rubygems.org"
ruby "2.1.5"

gem 'activesupport', '~> 4.1.4'
gem 'activerecord', '~> 4.1.4'

gem 'bugsnag'
gem 'faraday'
gem 'loofah'
gem 'newrelic_rpm', '~>3.8' # used both in production and development
gem 'petroglyph'
gem 'pg'
# Pony must not be required. See
# http://stackoverflow.com/questions/14824179/typeerror-cannot-visit-mailmultibytechars
gem 'pony', '~> 1.6', require: false
gem 'puma'
gem 'rack-flash3', require: 'rack-flash'
gem 'rake'
gem 'redcarpet', '~> 3.1'
gem 'rouge', '~> 1.3'
gem 'sinatra', '~> 1.4.4', require: 'sinatra/base'
gem 'sinatra-contrib'
gem 'sidekiq'
gem 'will_paginate'
gem 'will_paginate-bootstrap'
gem 'github_api'

# Frontend Gems
gem 'sass'
gem 'compass'
gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'kss'

group :test, :development do
  gem 'pry'
  gem 'thin'
  # gem 'ruby-prof', '~> 0.14'
  gem 'database_cleaner', require: false
  gem 'approvals', require: false
  gem 'rack-test', require: false
  gem 'mocha', require: false
  gem 'simplecov', require: false
  gem 'coveralls', require: false
  gem 'foreman', require: false
  gem 'sqlite3'
  gem 'timecop', require: false
  gem 'thin'
  # gem 'debugger'
end

group :test do
  gem 'launchy'
  gem 'minitest-capybara'
end
