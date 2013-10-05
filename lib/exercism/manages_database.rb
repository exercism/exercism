require 'active_record'
require 'db/config'
# require 'pg'

class ManagesDatabase

  def self.establish_connection
    new.establish_connection
  end

  def establish_connection
    ActiveRecord::Base.establish_connection(config)
  end

  def environment
    ENV.fetch('RACK_ENV') { 'development'}
  end

  def config
    @config ||= DB::Config.new(environment).options
  end

end
