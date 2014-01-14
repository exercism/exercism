namespace :delete do
  desc "delete left-over stashed submissions"
  task :stashed_submissions do
    require 'active_record'
    require 'db/connection'
    DB::Connection.establish

    sql = "DELETE FROM submissions WHERE state='stashed'"
    ActiveRecord::Base.connection.execute(sql)
  end
end

