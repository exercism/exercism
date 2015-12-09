require 'active_record'
require 'pg'
require_relative 'config'

module DB
  class Connection
    def self.escape(string)
      # escape strings passed to SQL using PG::Connection instance method as per
      # http://deveiate.org/code/pg/PG/Connection.html#method-i-escape_string
      conn = PG::Connection.open(dbname: 'postgres')
      conn.escape_string(string)
    end

    def self.establish
      new.establish
    end

    def establish
      ActiveRecord::Base.establish_connection(config)
    end

    def config
      @config ||= DB::Config.new.options
    end
  end
end
