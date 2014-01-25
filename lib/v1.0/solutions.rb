class ExercismV1p0 < Sinatra::Base
  get '/solutions' do
    please_login

    haml :"solutions/index"
  end
end
