$:.unshift File.expand_path("./../lib", __FILE__)

require 'bundler'
Bundler.require

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

run ExercismApp

map '/api/v1/' do
  run ExercismAPI
end
