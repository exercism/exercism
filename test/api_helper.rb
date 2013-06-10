require './test/integration_helper'

require 'sinatra/base'
require 'rack/test'
require 'rack-flash'
require 'approvals'

require 'app'

Approvals.configure do |c|
  c.approvals_path = './test/fixtures/approvals/'
end

