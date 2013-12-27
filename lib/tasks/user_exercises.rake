require 'active_record'
require 'exercism/use_cases/updates_user_exercise'
require 'exercism/user_exercise'

class Submission < ActiveRecord::Base
  belongs_to :user_exercise
end

namespace :migrate do
  desc "migrate user exercise data"
  task :user_exercises do
    require 'db/connection'
    DB::Connection.establish

    sql = "SELECT DISTINCT user_id, language, slug FROM submissions WHERE user_exercise_id IS NULL"
    ActiveRecord::Base.connection.execute(sql).each do |result|
      begin
        Hack::UpdatesUserExercise.new(result["user_id"], result["language"], result["slug"]).update
        print "."
      rescue => e
        puts
        puts e.message
      end
    end
    puts
  end

  desc "migrate user exercise keys"
  task :user_exercise_keys do
    require 'db/connection'
    DB::Connection.establish

    UserExercise.find_each do |exercise|
      exercise.key = exercise.generate_key
      exercise.save
    end
  end
end

