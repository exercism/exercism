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

  post '/teams/:slug/members' do |slug|
    please_login

    team = Team.where(slug: slug).first

    if team
      unless team.creator == current_user
        flash[:error] = "You are not allowed to add team members."
        redirect "/"
      end

      team.recruit(params[:usernames])
      team.save

      redirect "/teams/#{team.slug}"
    else
      flash[:error] = "We don't know anything about team '#{slug}'"
      redirect '/'
    end
  end

  put '/teams/:slug/leave' do |slug|
    please_login

    team = Team.where(slug: slug).first

    if team
      team.dismiss(current_user.username)

      redirect "/#{current_user.username}"
    else
      flash[:error] = "We don't know anything about team '#{slug}'"
      redirect '/'
    end
  end

  delete '/teams/:slug/members/:username' do |slug, username|
    please_login

    team = Team.where(slug: slug).first

    if team
      unless team.creator == current_user
        flash[:error] = "You are not allowed to remove team members."
        redirect "/"
      end

      team.dismiss(username)

      redirect "/teams/#{team.slug}"
    else
      flash[:error] = "We don't know anything about team '#{slug}'"
      redirect '/'
    end
  end
end
