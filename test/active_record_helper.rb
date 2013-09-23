require './test/test_helper'
require 'active_record'

ManagesDatabase.establish_connection

module WithRollback
  def temporarily(&block)
    ActiveRecord::Base.connection.transaction do
      block.call
      raise ActiveRecord::Rollback
    end
  end
end
