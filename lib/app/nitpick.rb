class ExercismApp < Sinatra::Base

  get '/nitpick' do
    erb :"about/nitpick"
  end

end
