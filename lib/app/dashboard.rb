class ExercismApp < Sinatra::Base

['/dashboard/:language/:slug/?', '/dashboard/:language/?'].each do |route|
  get route do
    please_login

    presenter = current_user.sees?(params[:language]) ? Dashboard : NullDashboard
    dashboard = presenter.new(current_user, params[:language], params[:slug] || 'no-nits')

    locals = {
      show_filters: dashboard.show_filters?,
      submissions: dashboard.submissions,
      language: dashboard.language,
      exercise: dashboard.slug,
      exercises: dashboard.available_exercises,
      breakdown: dashboard.breakdown
    }
    erb :dashboard, locals: locals
  end
end

end
