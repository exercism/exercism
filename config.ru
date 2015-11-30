$:.unshift File.expand_path("./..", __FILE__)
$:.unshift File.expand_path("./../lib", __FILE__)

require 'bundler'
Bundler.require
I18n.enforce_available_locales = false

if ENV['RACK_ENV'] != 'production'
  require 'dotenv'
  Dotenv.load
end

require 'app'
require 'api/v1'

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
use Rack::MethodOverride
run ExercismWeb::App

map '/api/v1/' do
  run ExercismAPI::App
end
