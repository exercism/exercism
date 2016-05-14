require_relative './test_helper'
require 'exercism'
require 'approvals'

Approvals.configure do |c|
  c.excluded_json_keys = {
    id: /(\A|_)id$/,
    uuid: /(\A|_)uuid$/,
    submission_path: /submission_path/,
    url: /^url$/,
  }
  c.approvals_path = Exercism.relative_to_root('test', 'fixtures', 'approvals') + '/'
end
