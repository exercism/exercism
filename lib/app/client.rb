class ExercismApp < Sinatra::Base

  get '/' do
    if current_user.guest?
      erb :index
    else
      pending = Submission.pending.select do |submission|
        current_user.may_nitpick?(submission.exercise)
      end
      erb :dashboard, locals: {pending: pending}
    end
  end

  get '/account' do
    if current_user.guest?
      flash[:error] = 'You must log in to go there.'
      redirect '/'
    end
    unstarted = Exercism.current_curriculum.unstarted_trails(current_user.current_languages)
    erb :account, locals: {unstarted: unstarted}
  end

end
