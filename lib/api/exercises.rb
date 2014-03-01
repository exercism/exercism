class ExercismAPI < Sinatra::Base
  get '/exercises/active' do
    require_user
    current_user.exercises.active.map {|exercise|
      {exercise.language => exercise.slug}
    }.to_json
  end
end
