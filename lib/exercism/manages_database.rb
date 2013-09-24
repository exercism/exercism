require 'active_record'
# require 'pg'

class ManagesDatabase

  def self.establish_connection
    new.establish_connection
  end

  def initialize
    @options = {adapter: 'sqlite3', database: 'test.sqlite'}
  end

  def establish_connection
    ActiveRecord::Base.establish_connection(@options)
  end

end
