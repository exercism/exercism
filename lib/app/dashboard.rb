class ExercismApp < Sinatra::Base

['/dashboard/:language/:exercise/?', '/dashboard/:language/?'].each do |route|
  get route do
    please_login route

    language, exercise = params[:language], params[:exercise]
    dashboard = Dashboard.new(current_user).in(language).for(exercise)

    locals = {
      language: language,
      exercise: exercise,
      submissions: dashboard.submissions,
      exercises: dashboard.exercises,
      breakdown: dashboard.breakdown
    }
    erb :dashboard, locals: locals
  end
end

end
