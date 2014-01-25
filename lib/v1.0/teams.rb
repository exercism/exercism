class ExercismV1p0 < Sinatra::Base
  get '/teams/:slug' do |slug|
    please_login

    haml :"teams/show"
  end
end
