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
      notify(team.unconfirmed_members, team)
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

      erb :"teams/show", locals: {team: team, members: team.all_members.sort_by {|m| m.username.downcase}}
    else
      flash[:error] = "We don't know anything about team '#{slug}'"
      redirect '/'
    end
  end

  delete '/teams/:slug' do |slug|
    please_login

    team = Team.where(slug: slug).first

    if team
      unless team.creator == current_user
        flash[:error] = "You are not allowed to delete the team."
        redirect '/'
      end

      team.destroy

      redirect '/account'
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
      invitees = User.find_in_usernames(params[:usernames].to_s.scan(/[\w-]+/))
      notify(invitees, team)

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

  put '/teams/:slug' do |slug|
    please_login

    EditsTeam.new(self).update(slug, params[:team])
  end

  put '/teams/:slug/confirm' do |slug|
    please_login

    team = Team.where(slug: slug).first

    if team
      unless team.unconfirmed_members.include?(current_user)
        flash[:error] = "You don't have a pending invitation to this team."
        redirect "/"
      end

      team.confirm(current_user.username)

      redirect "/teams/#{team.slug}"
    else
      flash[:error] = "We don't know anything about team '#{slug}'"
      redirect '/'
    end
  end

  def team_updated(slug)
    redirect "/teams/#{slug}"
  end

  def team_invalid(slug)
    flash[:error] = "Slug can't be blanked"
    redirect "/teams/#{slug}"
  end

  private

  def notify(invitees, team)
    invitees.each do |invitee|
      TeamNotification.on(team, to: invitee, regarding: 'invitation')
      begin
        TeamInvitationMessage.ship(
          instigator: team.creator,
          target: {
            team_name: team.name,
            invitee: invitee
          },
          site_root: site_root
        )
      rescue => e
        puts "Failed to send email. #{e.message}."
      end
    end
  end

end
