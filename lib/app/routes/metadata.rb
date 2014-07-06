module ExercismWeb
  module Routes
    class Metadata < Core
      get '/exercises/:language/:slug' do |language, slug|
        _, response = Xapi.get("assignments", language, slug)
        exercise = JSON.parse(response)["assignments"].first
        language = exercise["track"]
        slug = exercise["slug"]
        text = exercise["files"].find {|filename, code| filename =~ /test/i || filename =~ /\.t$/}.last
        erb :"exercises/test_suite", locals: {language: language, slug: slug, text: text}
      end

      get '/exercises/:language/:slug/readme' do |language, slug|
        _, response = Xapi.get("assignments", language, slug)
        exercise = JSON.parse(response)["assignments"].first
        text = exercise["files"].find {|key, value| key == "README.md"}.last
        erb :"exercises/readme", locals: {text: text, exercise: exercise}
      end
    end
  end
end
