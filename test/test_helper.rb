$:.unshift File.expand_path("../../lib", __FILE__)

ENV['RACK_ENV'] = 'test'
require 'simplecov' if ENV['COVERAGE']

gem 'minitest', '=5.3.5'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
