class ExercismAPI < Sinatra::Base
  get '/iterations/latest' do
    require_user
    content_type 'application/json', :charset => 'utf-8'

    submissions = current_user.exercises.order(:language, :slug).map {|exercise|
      exercise.submissions.last
    }
    pg :iterations, locals: {submissions: submissions}
  end
end
