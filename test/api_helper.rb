require 'simplecov' if ENV['COVERAGE']

require_relative 'test_helper'
require_relative './integration_helper'
require_relative './approvals_hack'

require 'sinatra/base'
require 'rack/test'
require 'rack-flash'

require_relative '../api/v1'
require_relative './app_test_helper'
