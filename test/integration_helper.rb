require './test/mongo_helper'

require 'approvals'
require 'exercism'

Approvals.configure do |c|
  c.approvals_path = './test/fixtures/approvals/'
end

