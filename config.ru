$:.unshift File.expand_path("./../lib", __FILE__)

require 'bundler'
Bundler.require

Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY']
end

require 'app'
require 'api'

ENV['RACK_ENV'] ||= 'development'

key = ENV['NEW_RELIC_LICENSE_KEY']
if key
  NewRelic::Agent.manual_start(license_key: key)
end

if ENV['RACK_ENV'].to_sym == :development
  require 'new_relic/rack/developer_mode'
  use NewRelic::Rack::DeveloperMode
end

use ActiveRecord::ConnectionAdapters::ConnectionManagement
run ExercismWeb::App

map '/api/v1/' do
  run ExercismAPI::App
end
