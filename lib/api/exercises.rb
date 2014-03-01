class ExercismAPI < Sinatra::Base
  get '/exercises' do
    require_user
    current_user.exercises.map {|exercise|
      {exercise.language => exercise.slug}
    }.to_json
  end
end
