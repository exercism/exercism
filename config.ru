$:.unshift File.expand_path("./../lib", __FILE__)

require 'bundler'
Bundler.require

require 'app'

key = ENV['NEW_RELIC_LICENSE_KEY']
if key
  NewRelic::Agent.manual_start(license_key: key)
end

run ExercismApp

