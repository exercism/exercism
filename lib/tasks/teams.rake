namespace :teams do
  namespace :delete do
    desc "Delete superseded team invitations"
    task :invitation_notifications do
      require 'active_record'
      require 'db/connection'
      DB::Connection.establish

      sql = "DELETE FROM notifications WHERE regarding='invitation'"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
