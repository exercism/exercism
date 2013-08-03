require 'app/presenters/dashboard'
class ExercismApp < Sinatra::Base

  get '/dashboard/:language' do |language|
    if current_user.guest?
      erb :index
    else
      dashboard = Dashboard.new(current_user, Submission.pending_for_language(language))

      locals = {
        submissions: dashboard.submissions,
        filters: dashboard.filters
      }
      erb :dashboard, locals: locals
    end
  end

end
