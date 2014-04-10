require 'exercism/xapi'

class ExercismApp < Sinatra::Base
  get '/exercises/:language/:slug' do |language, slug|
    response = Xapi.get("exercises", language, slug)
    exercise = JSON.parse(response)["assignments"].first
    language = exercise["track"]
    slug = exercise["slug"]
    text = exercise["files"].find {|filename, code| filename =~ /test/i}.last
    erb :"exercises/test_suite", locals: {language: language, slug: slug, text: text}
  end

  get '/exercises/:language/:slug/readme' do |language, slug|
    response = Xapi.get("exercises", language, slug)
    exercise = JSON.parse(response)["assignments"].first
    text = exercise["files"].find {|key, value| key == "README.md"}.last
    erb :"exercises/readme", locals: {text: text}
  end

  post '/exercises/:language/:slug' do |language, slug|
    please_login

    exercise = current_user.exercises.where(language: language, slug: slug).first
    exercise.unlock! if exercise
    redirect back
  end
end
