require 'app/presenters/dashboard'
class ExercismApp < Sinatra::Base

['/dashboard/:language/:exercise/', '/dashboard/:language/?'].each do |route|
  get route do
    language, exercise = params[:language], params[:exercise]
    if current_user.guest?
      erb :index
    else
      dashboard = Dashboard.new(current_user, Submission.pending_for(language, exercise))

      locals = {
        submissions: dashboard.submissions,
        language: language,
        exercise: exercise
      }
      erb :dashboard, locals: locals
    end
  end
end

end
