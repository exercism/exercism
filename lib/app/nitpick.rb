class ExercismApp < Sinatra::Base

  get '/nitpick' do
    erb :"about/nitpick"
  end

  post '/preview' do
    md(params[:comment])
  end

end
