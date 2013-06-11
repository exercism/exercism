class ExercismApp < Sinatra::Base

  get '/' do
    if current_user.guest?
      erb :index
    elsif current_user.admin?
      erb :admin
    else
      erb :dashboard
    end
  end

end
