class ExercismApp < Sinatra::Base

  get '/' do
    if current_user.guest?
      erb :index
    else
      pending = Submission.pending.select do |submission|
        current_user.may_nitpick?(submission.exercise)
      end

      users = pending.map { |s| s.user.username }.uniq.sort
      exercises = pending.map { |s| s.slug }.uniq.sort
      languages = pending.map { |s| s.language }.uniq.sort

      erb :dashboard, locals: {pending: pending, users: users,
                               exercises: exercises, languages: languages}
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
