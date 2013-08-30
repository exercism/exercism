class ExercismApp < Sinatra::Base

  post '/preview' do
    md(params[:comment])
  end

end
