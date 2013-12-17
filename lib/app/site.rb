require 'app/site/languages'

class ExercismApp < Sinatra::Base

  get '/' do
    if current_user.guest?
      languages = Exercism.current_curriculum.trails.map {|key, trail| trail.name}
      erb :index, locals: {languages: App::Site::Languages.new(languages)}
    else
      erb :dashboard, locals: {submission: Work.new(current_user).random}
    end
  end

end
