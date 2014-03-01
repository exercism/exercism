class ExercismAPI < Sinatra::Base
  get '/exercises' do
    require_user
    content_type 'application/json', :charset => 'utf-8'
    sql = "SELECT language, slug FROM user_exercises WHERE user_id = %s" % current_user.id.to_s
    exercises = Hash.new {|exercises, key| exercises[key] = []}
    UserExercise.connection.execute(sql).each_with_object(exercises) {|row, exercises|
      exercises[row['language']] << row["slug"]
    }.to_json
  end
end
