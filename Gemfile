source "http://rubygems.org"

ruby "1.9.3"

gem 'rake'
gem 'faraday'
gem 'mongoid'
gem 'petroglyph'
gem 'puma'
gem 'rack-flash3', require: 'rack-flash'
gem 'redcarpet'
gem 'rouge', git: 'https://github.com/jayferd/rouge.git' # master to see if it fixes #157
gem 'sinatra', require: 'sinatra/base'
gem 'pony'
gem 'sanitize'
gem 'will_paginate', git: 'https://github.com/mislav/will_paginate.git' # master for mongoid support
gem 'will_paginate-bootstrap'
gem 'pry', require: false
gem 'newrelic_rpm', "3.5.8.72"

group :test, :development do
  gem 'ruby-prof'
  gem 'minitest', '~> 5.0', require: false
  gem 'approvals', require: false
  gem 'rack-test', require: false
  gem 'mocha', require: false
  gem 'simplecov', require: false
  gem 'json_expressions', require: false
  gem 'mailcatcher', require: false # for Travis-CI
end
