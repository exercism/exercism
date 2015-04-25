ENV['RACK_ENV'] = 'test'
require 'bundler'
Bundler.require
require_relative './active_record_helper'
require 'exercism'
require 'app'
require 'capybara'
require 'minitest-capybara'
require_relative './tracks_helper'
require_relative './acceptance/acceptance_test_case'

ENV['EXERCISM_GITHUB_CLIENT_ID'] = 'abc123'
ENV['EXERCISM_GITHUB_CLIENT_SECRET'] = 'abcdef123456'

Capybara.app = ExercismWeb::App
