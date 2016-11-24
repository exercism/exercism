task :connection do
  require 'active_record'
  require 'db/connection'
  DB::Connection.establish
end
