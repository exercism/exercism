namespace :data do
  namespace :migrate do
    desc "migrate nitpicker status"
    task :nitpicker_status do
      require 'bundler'
      Bundler.require
      require_relative '../db/connection'
      DB::Connection.establish

      sql = "UPDATE user_exercises SET is_nitpicker='t' WHERE state='done'"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end

