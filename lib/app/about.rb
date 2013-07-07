class ExercismApp < Sinatra::Base

  get '/cycle' do
    erb :"about/cycle"
  end

end
