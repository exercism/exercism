require 'app/presenters/dashboard'
class ExercismApp < Sinatra::Base

['/gallery/:language/:exercise/', '/gallery/:language/?'].each do |route|
  get route do
    language, exercise = params[:language], params[:exercise]
    if current_user.guest?
      erb :index
    else
      dashboard = Dashboard.new(current_user, Submission.approved_for(language, exercise))

      locals = {
        submissions: dashboard.submissions,
        filters: dashboard.filters,
        language: language,
        exercise: exercise
      }
      erb :gallery, locals: locals
    end
  end
end

end
