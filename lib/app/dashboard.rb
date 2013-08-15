require 'app/presenters/dashboard'
class ExercismApp < Sinatra::Base

['/dashboard/:language/:exercise/?', '/dashboard/:language/?'].each do |route|
  get route do
    please_login route

    language, exercise = params[:language], params[:exercise]
    dashboard = Dashboard.new(current_user, Submission.pending_for(language, exercise))

    locals = {
      submissions: dashboard.submissions,
      language: language,
      exercise: exercise,
      exercises: exercises_available_for(language),
      breakdown: Breakdown.of(language)
    }
    erb :dashboard, locals: locals
  end
end

end
