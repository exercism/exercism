require 'active_record'
require 'db/config'
# require 'pg'

module DB
  class Connection

    def self.establish
      new.establish
    end

    def establish
      ActiveRecord::Base.establish_connection(config)
    end

    def environment
      ENV.fetch('RACK_ENV') { 'development'}
    end

    def config
      @config ||= DB::Config.new(environment).options
    end
  end
end
