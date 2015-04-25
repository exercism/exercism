require 'simplecov' if ENV['COVERAGE']
require_relative './integration_helper'
require_relative './approval_helper'

require 'sinatra/base'
require 'rack/test'
require 'rack-flash'

require 'app'
require_relative './tracks_helper'
require_relative './app_test_helper'
