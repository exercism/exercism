module ExercismWeb
  module Routes
    class Teams < Core
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

        team = Team.find_by_slug(slug)

        if team

          unless team.includes?(current_user)
            flash[:error] = "You may only view team pages for teams that you are a member of, or that you manage."
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

        team = Team.find_by_slug(slug)

        if team
          unless team.managed_by?(current_user)
            flash[:error] = "You are not allowed to delete the team."
            redirect "/teams/#{slug}"
          end

          team.destroy

          flash[:success] = "Team #{slug} has been destroyed"
          redirect "/account"
        else
          flash[:error] = "We don't know anything about team '#{slug}'"
          redirect '/'
        end
      end

      post '/teams/:slug/members' do |slug|
        please_login

        team = Team.find_by_slug(slug)

        if team
          unless team.managed_by?(current_user)
            flash[:error] = "You are not allowed to add team members."
            redirect "/teams/#{slug}"
          end

          team.recruit(params[:usernames])
          team.save
          invitees = ::User.find_in_usernames(params[:usernames].to_s.scan(/[\w-]+/))
          notify(invitees, team)

          redirect "/teams/#{slug}"
        else
          flash[:error] = "We don't know anything about team '#{slug}'"
          redirect '/'
        end
      end

      put '/teams/:slug/leave' do |slug|
        please_login

        team = Team.find_by_slug(slug)

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

        team = Team.find_by_slug(slug)

        if team
          unless team.managed_by?(current_user)
            flash[:error] = "You are not allowed to remove team members."
            redirect "/teams/#{slug}"
          end

          team.dismiss(username)

          redirect "/teams/#{slug}"
        else
          flash[:error] = "We don't know anything about team '#{slug}'"
          redirect '/'
        end
      end

      put '/teams/:slug' do |slug|
        please_login

        team = Team.find_by_slug(slug)

        if team
          unless team.managed_by?(current_user)
            flash[:error] = "You are not allowed to edit the team."
            redirect "/teams/#{slug}"
          end

          if team.defined_with(params[:team]).save
            redirect "/teams/#{team.slug}"
          else
            flash[:error] = "Slug can't be blank"
            redirect "/teams/#{team.slug}"
          end
        end
      end

      put '/teams/:slug/confirm' do |slug|
        please_login

        team = Team.find_by_slug(slug)

        if team
          unless team.unconfirmed_members.include?(current_user)
            flash[:error] = "You don't have a pending invitation to this team."
            redirect "/"
          end

          team.confirm(current_user.username)

          redirect "/teams/#{slug}"
        else
          flash[:error] = "We don't know anything about team '#{slug}'"
          redirect '/'
        end
      end

      post "/teams/:slug/managers" do |slug|
        please_login

        team = Team.find_by_slug(slug)

        unless team.managed_by?(current_user)
          flash[:error] = "You are not allowed to add managers to the team."
          redirect "/teams/#{slug}"
        end

        user = ::User.find_by_username(params[:username])
        unless user.present?
          flash[:error] = "Unable to find user #{params[:username]}"
          redirect "/teams/#{slug}"
        end

        team.managed_by(user)

        redirect "/teams/#{slug}"
      end

      delete "/teams/:slug/managers" do |slug|
        please_login

        team = Team.find_by_slug(slug)

        unless team.managed_by?(current_user)
          flash[:error] = "You are not allowed to add managers to the team."
          redirect "/teams/#{slug}"
        end

        user = ::User.find_by_username(params[:username])
        team.managers.delete(user) if user
        redirect "/teams/#{slug}"
      end

      post "/teams/:slug/disown" do |slug|
        please_login("/teams/#{slug}")

        team = Team.find_by_slug(slug)

        if team.managers.size == 1
          flash[:error] = "You can't quit when you're the only manager."
          redirect "/teams/#{slug}"
        else
          team.managers.delete(current_user)
          redirect "/account"
        end
      end

      private

      def notify(invitees, team)
        invitees.each do |invitee|
          attributes = {
            user_id: invitee.id,
            url: '/account',
            text: "#{current_user.username} would like you to join the team #{team.name}. You can accept the invitation",
            link_text: 'on your account page.'
          }
          Alert.create(attributes)
          begin
            TeamInvitationMessage.ship(
              instigator: current_user,
              target: {
                team_name: team.name,
                invitee: invitee
              },
              site_root: site_root
            )
          rescue => e
            unless ENV['RACK_ENV'] == 'test'
              puts "Failed to send email. #{e.message}."
            end
          end
        end
      end
    end
  end
end
