class ExercismV1p0 < Sinatra::Base
  get '/' do
    haml :"site/index"
  end

  get '/about' do
    current = App::Site::Languages.new(Exercism.current)
    upcoming = App::Site::Languages.new(Exercism.upcoming)
    haml :"site/about", locals: {current: current, upcoming: upcoming}
  end
end
