class ExercismApp < Sinatra::Base

  get '/completed/:language/:slug/random' do |language, slug|
    please_login

    language, slug = language.downcase, slug.downcase

    exercise = Exercise.new(language, slug)

    unless current_user.nitpicker_on?(exercise)
      flash[:notice] = "You'll have access to that page when you complete #{slug} in #{language}"
      redirect '/'
    end

    submission = Submission.random_completed_for(exercise)
    total = Submission.completed_for(exercise).count

    erb :random_completed, locals: {submission: submission, total: total}
  end

  get '/completed/:language/:slug' do |language, slug|
    please_login

    language, slug = language.downcase, slug.downcase

    exercise = Exercise.new(language, slug)

    unless current_user.nitpicker_on?(exercise)
      flash[:notice] = "You'll have access to that page when you complete #{slug} in #{language}"
      redirect '/'
    end

    submissions = Submission.completed_for(exercise)
                            .paginate(page: params[:page], per_page: per_page)

    erb :completed, locals: {language: language, slug: slug, submissions: submissions}
  end

  private

  def per_page
    params[:per_page] || 50
  end

end
