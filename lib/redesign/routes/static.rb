module ExercismIO
  module Routes
    class Static < Core
      get '/about' do
        haml :"static/about"
      end

      get '/getting-started' do
        languages = ExercismIO::Presenters::Languages.new(Exercism::Config.current)
        haml :"static/getting-started", locals: {languages: languages}
      end

      get '/blog' do
        haml :"static/blog"
      end
    end
  end
end
