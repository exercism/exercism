require "English"

$LOAD_PATH.unshift File.expand_path("./..", __FILE__)
$LOAD_PATH.unshift File.expand_path("./../lib", __FILE__)

require 'bundler'
Bundler.require
I18n.enforce_available_locales = false

if ENV['RACK_ENV'] == 'development'
  require 'active_record'
  require 'db/connection'
  DB::Connection.establish
  if defined?(ActiveRecord::Migrator) && ActiveRecord::Migrator.needs_migration?
    fail 'Migrations are pending run `rake db:migrate` to resolve the issue.'
  end
end

if ENV['RACK_ENV'] != 'production'
  require 'dotenv'
  Dotenv.load
end

require 'app'
require 'flipper_app'
require 'api/v1'

ENV['RACK_ENV'] ||= 'development'

use Rack::MethodOverride
run Rack::URLMap.new(
  "/" => ExercismWeb::App,
  "/flipper" => Flipper::UI.app($flipper, &FlipperApp.generator)
)


require 'api/xapi'
map '/xapi' do
  run Xapi::App
end

map '/api/v1/' do
  run ExercismAPI::App
end
