class ExercismApp < Sinatra::Base
  get '/exercises/:language/:slug' do |language, slug|
    assignment = Assignment.new(language, slug, Exercism.curriculum.path)
    erb :"exercises/test_suite", locals: {assignment: assignment}
  end

  get '/exercises/:slug' do |slug|
    erb :"exercises/readme", locals: {readme: Readme.new(slug).text}
  end

  post '/exercises/:language/:slug' do |language, slug|
    please_login

    exercise = current_user.exercises.where(language: language, slug: slug).first
    exercise.unlock! if exercise
    redirect back
  end
end
