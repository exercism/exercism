require 'app/presenters/dashboard'
class ExercismApp < Sinatra::Base

['/dashboard/:language/:exercise/?', '/dashboard/:language/?'].each do |route|
  get route do
    if current_user.guest?
      erb :index
    else
      language, exercise = params[:language], params[:exercise]
      dashboard = Dashboard.new(current_user).in(language).for(exercise)
      locals = {
        featured: false,
        submissions: dashboard.submissions,
        exercises: dashboard.exercises,
        breakdown: dashboard.breakdown,
        language: language,
        exercise: exercise
      }
      erb :dashboard, locals: locals
    end
  end
end

end
