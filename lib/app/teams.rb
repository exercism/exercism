class ExercismApp < Sinatra::Base

  get '/teams/:slug' do |slug|
    please_login

    team = Team.where(slug: slug).first
    if team
      erb :"teams/show", locals: {team: team, members: team.members.sort_by {|m| m.username.downcase}}
    else
      flash[:error] = "We don't know anything about team '#{slug}'"
      redirect '/'
    end
  end

end
