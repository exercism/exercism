class ExercismApp < Sinatra::Base

  get '/' do
    if current_user.guest?
      erb :index
    else
      pending = Submission.pending.select do |submission|
        current_user.may_nitpick?(submission.exercise)
      end
      if current_user.admin?
        erb :admin, locals: {pending: pending}
      else
        erb :dashboard, locals: {pending: pending}
      end
    end
  end

  get '/account' do
    erb :account
  end

end
