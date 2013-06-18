class ExercismApp < Sinatra::Base

  get '/' do
    if current_user.guest?
      erb :index
    else
      pending = Submission.pending.select do |submission|
        current_user.may_nitpick?(submission.exercise)
      end
      unstarted = Exercism.current_curriculum.unstarted_trails(current_user.current_languages)
      if current_user.admin?
        erb :admin, locals: {pending: pending, unstarted: unstarted}
      else
        erb :dashboard, locals: {pending: pending, unstarted: unstarted}
      end
    end
  end

  get '/account' do
    unless current_user.guest?
      flash[:error] = 'You must log in to go there.'
      redirect '/'
    end
    erb :account
  end

end
