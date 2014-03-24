module ExercismIO
  module Routes
    class Static < Core
      get '/about' do
        haml :"static/about"
      end

      get '/getting-started' do
        languages = ExercismIO::Presenters::Languages.new(Exercism::Config.current)
        code_dir = File.join('./lib', 'redesign', 'presenters', 'carousel')
        slides = ExercismIO::Presenters::Carousel.slides(code_dir)
        haml :"static/getting-started", locals: {languages: languages, slides: slides}
      end

      get '/blog' do
        haml :"static/blog"
      end
    end
  end
end
