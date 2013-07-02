$:.unshift File.expand_path("./../../lib", __FILE__)
require 'bundler'
Bundler.require
require 'exercism'
require 'services'

ENV['RACK_ENV'] ||= 'development'
