ENV['RACK_ENV'] = 'test'
require 'bundler'
Bundler.require
require_relative './active_record_helper'
require 'exercism'
require_relative './tracks_helper'
require_relative './x_helper'
