ENV['RACK_ENV'] = 'test'
require 'bundler'
Bundler.require
require_relative './active_record_helper'
require 'exercism'

Trackler.use_fixture_data
