$:.unshift File.expand_path("../../lib", __FILE__)

ENV['RACK_ENV'] = 'test'
require 'simplecov' if ENV['COVERAGE']

require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
