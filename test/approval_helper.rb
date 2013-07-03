require './test/test_helper'

require 'approvals'
Approvals.configure do |c|
  c.approvals_path = './test/fixtures/approvals/'
end

