require 'app/presenters/dashboard'
class ExercismApp < Sinatra::Base

  get '/' do
    if current_user.guest?
      erb :index
    else
      dashboard = Dashboard.new(current_user, Submission.pending)

      locals = {
        submissions: dashboard.submissions,
        filters: dashboard.filters
      }
      erb :dashboard, locals: locals
    end
  end

  get '/account' do
    if current_user.guest?
      redirect login_url("/account")
    end
    unstarted = Exercism.current_curriculum.unstarted_trails(current_user.current_languages)
    erb :account, locals: {unstarted: unstarted}
  end

  put '/account/email' do
    if current_user.guest?
      redirect login_url("/account")
    else
      current_user.email = params[:email]
      current_user.save
      redirect '/account'
    end
  end

end
