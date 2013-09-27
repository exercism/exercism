ENV['RACK_ENV'] = 'test'
require 'bundler'
Bundler.require
require './test/mongo_helper'

require 'exercism'
