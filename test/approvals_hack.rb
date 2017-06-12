require 'approvals'

module Approvals
  def self.configure_for_xapi
    configure do |c|
      c.excluded_json_keys = {}
      c.approvals_path = File.expand_path(File.join('..', 'fixtures', 'approvals'), __FILE__) + '/'
    end
  end

  def self.configure_for_io
    configure do |c|
      c.excluded_json_keys = {
        id: /(\A|_)id$/,
        uuid: /(\A|_)uuid$/,
        submission_path: /submission_path/,
        url: /^url$/,
      }
      c.approvals_path = File.expand_path(File.join('..', 'fixtures', 'approvals'), __FILE__) + '/'
    end
  end
end

Approvals.configure_for_io
