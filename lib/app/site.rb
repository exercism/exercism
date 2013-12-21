require 'app/site/languages'

class ExercismApp < Sinatra::Base

  get '/' do
    if current_user.guest?
      erb :index, locals: {languages: App::Site::Languages.new(Exercism.current)}
    else
      erb :dashboard, locals: {submission: Work.new(current_user).random}
    end
  end

  get '/privacy' do
    erb :privacy
  end

  get '/about' do
    erb :about
  end

end
