class ExercismApp < Sinatra::Base
  get '/code/:language/:slug/random' do |language, slug|
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
end
