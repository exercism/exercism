class ExercismApp < Sinatra::Base

  get '/user/:language/:slug' do |language, slug|
    if current_user.guest?
      redirect login_url("/user/#{language}/#{slug}")
    end
    redirect "/#{current_user.username}/#{language}/#{slug}"
  end

  get '/:username/:language/:slug' do |username, language, slug|
    if current_user.guest?
      redirect login_url("/#{username}/#{language}/#{slug}")
    end

    exercise = Exercise.new(language, slug)

    unless current_user.is?(username) || current_user.may_nitpick?(exercise)
      flash[:error] = "You can't go there yet. Sorry."
      redirect '/'
    end

    user = current_user if current_user.is?(username)
    user ||= User.where(username: username).first

    unless user
      flash[:error] = "We don't know anything about #{username}."
      redirect '/'
    end

    submissions = user.submissions_on(exercise)

    locals = {
      exercise: exercise,
      user: user,
      before: submissions.last,
      after: submissions.first,
      iterations: submissions
    }
    erb :summary, locals: locals
  end

end
