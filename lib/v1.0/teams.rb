class ExercismV1p0 < Sinatra::Base
  get '/teams/:slug' do |slug|
    please_login

    team = Team.find_by_slug(slug)
    haml :"teams/show", locals: {team: team}
  end
end
