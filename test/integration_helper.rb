ENV['RACK_ENV'] = 'test'
require 'bundler'
Bundler.require
require './test/active_record_helper'
require 'exercism'
