source "http://rubygems.org"

ruby "1.9.3"

gem 'rake'
gem 'faraday'
gem 'activerecord', '~>3.2.0'
gem 'database_cleaner'
gem 'newrelic_rpm', "3.5.8.72" # used both in production and development
gem 'petroglyph'
gem 'puma'
gem 'rack-flash3', require: 'rack-flash'
gem 'redcarpet'
gem 'rouge', github: 'jayferd/rouge', ref: '1822e646c6380215dbb4b777ab2bbacde892b363'
gem 'sinatra', require: 'sinatra/base'
gem 'loofah'
gem 'will_paginate', github: 'mislav/will_paginate', tag: "4cb4986d5ce05aa84572b05cfd1c1d0aa9bc07df"
gem 'will_paginate-bootstrap'
gem 'pry', require: false
gem 'airbrake'
gem 'diffy'

# Must not be required
# See http://stackoverflow.com/questions/14824179/typeerror-cannot-visit-mailmultibytechars
gem 'pony', require: false

group :test, :development do
  gem 'ruby-prof'
  gem 'minitest', '~> 5.0', require: false
  gem 'database_cleaner', require: false
  gem 'approvals', require: false
  gem 'rack-test', require: false
  gem 'mocha', require: false
  gem 'simplecov', require: false
  gem 'mailcatcher', require: false # for Travis-CI
  gem 'faker', require: false # for seed data
end

