class ExercismApp < Sinatra::Base

['/gallery/:language/:exercise/?', '/gallery/:language/?'].each do |route|
  get route do
    please_login route
    language, exercise = params[:language], params[:exercise]
    dashboard = Gallery.new(current_user, Submission.approved_for(language, exercise))

    locals = {
      submissions: dashboard.submissions,
      language: language,
      exercise: exercise,
      exercises: exercises_available_for(language)
    }
    erb :gallery, locals: locals
  end
end

end
