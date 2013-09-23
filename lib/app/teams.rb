class ExercismApp < Sinatra::Base

  get '/teams/?' do
    please_login

    erb :"teams/new", locals: {team: Team.new}
  end

  post '/teams/?' do
    please_login

    team = Team.by(current_user).defined_with(params[:team])
    if team.valid?
      team.save
      redirect "/teams/#{team.slug}"
    else
      erb :"teams/new", locals: {team: team}
    end
  end

  get '/teams/:slug' do |slug|
    please_login

    team = Team.where(slug: slug).first

    if team

      unless team.includes?(current_user)
        flash[:error] = "You may only view team pages for teams that you are on."
        redirect "/"
      end

      erb :"teams/show", locals: {team: team, members: team.members.sort_by {|m| m.username.downcase}}
    else
      flash[:error] = "We don't know anything about team '#{slug}'"
      redirect '/'
    end
  end

end
