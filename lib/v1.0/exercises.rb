class ExercismV1p0 < Sinatra::Base
  get '/exercises' do
    please_login

    haml :"exercises/index"
  end
end
