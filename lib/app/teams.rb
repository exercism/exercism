class ExercismApp < Sinatra::Base

  get '/teams/:slug' do |slug|
    please_login

    team = Team.where(slug: slug).first
    if team
      erb :team, locals: {team: team, members: team.members_with_pending_submissions}
    else
      flash[:error] = "We don't know anything about team '#{slug}'"
      redirect '/'
    end
  end

end
