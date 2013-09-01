class ExercismApp < Sinatra::Base

  get '/' do
    if current_user.guest?
      erb :index
    else
      erb :dashboard, locals: {submission: current_user.random_work}
    end
  end

  get '/about' do
    erb :about
  end

  put '/account/email' do
    if current_user.guest?
      halt 403, "You must be logged in to edit your email settings"
    end

    current_user.email = params[:email]
    current_user.save
    redirect "/#{current_user.username}"
  end

end
