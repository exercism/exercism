$:.unshift File.expand_path("../../lib", __FILE__)

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/pride'

