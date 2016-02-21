require 'pg'

require_relative '../lib/db/config'

def is_db_accepting_connections
  config = DB::Config.new.options
  result = PG::Connection.ping(
    :host => config['host'],
    :port => config['port'],
    :user => config['username'],
    :password => config['password'],
    :dbname => 'postgres',
    :connect_timeout => 1
  )
  result == PG::PQPING_OK
end

20.times do |n|
  puts "Waiting for db to accept connections (attempt ##{n+1})..."
  if is_db_accepting_connections
    exec *ARGV
  end
  sleep 0.5
end

Kernel.abort("Unable to connect to db.")
