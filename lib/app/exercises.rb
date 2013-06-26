class ExercismApp < Sinatra::Base

  get '/user/:language/:slug' do |language, slug|
    exercise = Exercise.new(language, slug)
    unless current_user.submitted?(exercise)
      flash[:error] = "You haven't submitted anything on this yet."
      redirect '/'
    end
    locals = {
      exercise: exercise,
      before: current_user.first_submission_on(exercise),
      after: current_user.latest_submission_on(exercise),
      iterations: current_user.submissions_on(exercise)
    }
    erb :summary, locals: locals
  end

end
