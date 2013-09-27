class ExercismApp < Sinatra::Base

  get '/completed/:language/:slug' do |language, slug|
    please_login

    language, slug = language.downcase, slug.downcase

    exercise = Exercise.new(language, slug)

    unless current_user.completed?(exercise)
      flash[:notice] = "You'll have access to that page when you complete #{slug} in #{language}"
      redirect '/'
    end

    submissions = Submission.completed_for(language, slug)
                            .paginate(page: params[:page], per_page: per_page)

    erb :completed, locals: {language: language, slug: slug, submissions: submissions}
  end

  get '/user/:language/:slug' do |language, slug|
    please_login

    redirect "/#{current_user.username}/#{language}/#{slug}"
  end

  get '/:username/:language/:slug' do |username, language, slug|
    title(slug + " in " + language + " by " + username)

    please_login

    exercise = Exercise.new(language, slug)

    unless current_user.is?(username) || current_user.nitpicker_on?(exercise)
      flash[:error] = "You can't go there yet. Sorry."
      redirect '/'
    end

    user = current_user if current_user.is?(username)
    user ||= User.find_by_username(username)

    unless user
      flash[:error] = "We don't know anything about #{username}."
      redirect '/'
    end

    submissions = user.submissions_on(exercise).reverse

    locals = {
      exercise: exercise,
      user: user,
      before: submissions.first,
      after: submissions.last,
      iterations: submissions
    }
    erb :summary, locals: locals
  end

  private

  def per_page
    params[:per_page] || 50
  end

end
