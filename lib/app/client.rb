require 'app/presenters/dashboard'
class ExercismApp < Sinatra::Base

  get '/' do
    if current_user.guest?
      erb :index
    else
      dashboard = Dashboard.new(current_user, Submission.nitless)

      locals = {
        submissions: dashboard.submissions,
        filters: dashboard.filters
      }
      erb :dashboard, locals: locals
    end
  end

  get '/account' do
    please_login("/account")

    unstarted = Exercism.current_curriculum.unstarted_trails(current_user.current_languages)
    erb :account, locals: {unstarted: unstarted}
  end

  put '/account/email' do
    if current_user.guest?
      halt 403, "You must be logged in to edit your email settings"
    end

    current_user.email = params[:email]
    current_user.save
    redirect '/account'
  end

end
