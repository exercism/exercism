class ExercismApp < Sinatra::Base

  get '/logout' do
    logout
    redirect '/'
  end

  get '/backdoor' do
    session[:github_id] = params[:id]
    redirect '/'
  end

end
