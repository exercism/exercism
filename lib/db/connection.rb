require 'active_record'
require_relative 'config'

module DB
  class Connection
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
