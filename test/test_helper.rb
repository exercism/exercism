$:.unshift File.expand_path("../../lib", __FILE__)

ENV['RACK_ENV'] = 'test'
require 'simplecov' if ENV['COVERAGE']

gem 'minitest', '=4.7.5'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
