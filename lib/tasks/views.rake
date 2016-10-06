namespace :views do
  desc "delete all the views below the watermarks"
  task :sweep do
    require 'active_record'
    require 'db/connection'
    require './lib/exercism/view'
    DB::Connection.establish

    View.delete_below_watermarks
  end
end
