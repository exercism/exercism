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
      if environment == "development" || environment == "test"
        args = ['..', '..', '..', 'config', 'database_dev.yml']
        dev_db_yml_path = File.expand_path(File.join(__FILE__, *args))
        @config ||= DB::Config.new(environment, dev_db_yml_path).options
      else
        @config ||= DB::Config.new(environment).options
      end
    end
  end
end
