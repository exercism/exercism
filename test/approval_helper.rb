require './test/test_helper'

require 'approvals'
Approvals.configure do |c|
  c.excluded_json_keys = { :id =>/(\A|_)id$/ }
  c.approvals_path = './test/fixtures/approvals/'
end

