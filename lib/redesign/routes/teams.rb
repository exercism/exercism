module ExercismIO
  module Routes
    class Teams < Core
      get '/teams/:slug' do |slug|
        team = Team.find_by_slug(slug)
        haml :"teams/show", locals: {team: team}
      end
    end
  end
end
