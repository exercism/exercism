ENV['RACK_ENV'] = 'test'
require 'bundler'
Bundler.require
require 'debugger'
require_relative './active_record_helper'
require 'exercism'
require 'app'
require 'capybara'
require 'minitest-capybara'
require_relative './acceptance/acceptance_test_case'
require 'dotenv'
Dotenv.load!

Capybara.app = ExercismWeb::App
