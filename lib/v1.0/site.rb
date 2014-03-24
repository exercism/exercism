class ExercismV1p0 < Sinatra::Base
  get '/' do
    haml :"site/index"
  end

  get '/about' do
    current = ExercismIO::Presenters::Languages.new(Exercism::Config.current)
    upcoming = ExercismIO::Presenters::Languages.new(Exercism::Config.upcoming)
    haml :"site/about", locals: {current: current, upcoming: upcoming}
  end

  get '/getting-started' do
    languages = ExercismIO::Presenters::Languages.new(Exercism::Config.current)
    code_dir = File.join('./lib', 'redesign', 'presenters', 'carousel')
    slides = ExercismIO::Presenters::Carousel.slides(code_dir)
    haml :"site/getting_started", locals: {languages: languages, slides: slides}
  end

  get '/ohai' do
    haml :"site/temporary_landing_page"
  end
end
