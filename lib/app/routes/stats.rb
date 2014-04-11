module ExercismWeb
  module Routes
    class Stats < Core
      get '/stats' do
        redirect "/stats/#{Exercism::Config.languages.first}"
      end

      get '/stats/:language' do |language|
        please_login

        languages = Exercism::Config.languages
        progress = progress(language)

        erb :"stats/show", locals: {trail: language, languages: languages, progress: progress}
      end
    end
  end
end
