module ExercismWeb
  module Routes
    class Teams < Core

      before do
        please_login
      end

      get '/teams/?' do
        erb :"teams/new", locals: {team: Team.new}
      end

      post '/teams/?' do
        team = Team.by(current_user).defined_with(params[:team], current_user)
        if team.valid?
          team.save
          team.recruit(current_user.username, current_user)
          team.confirm(current_user.username)
          redirect "/teams/#{team.slug}"
        else
          erb :"teams/new", locals: {team: team}
        end
      end

      get '/teams/:slug' do |slug|
        only_with_existing_team(slug) do |team|

          unless team.includes?(current_user)
            flash[:error] = "You may only view team pages for teams that you are a member of, or that you manage."
            redirect "/"
          end

          erb :"teams/show", locals: {team: team, members: team.all_members.sort_by {|m| m.username.downcase}}
        end
      end

      delete '/teams/:slug' do |slug|
        only_for_team_managers(slug, "You are not allowed to delete the team.") do |team|
          team.destroy

          flash[:success] = "Team #{slug} has been destroyed"
          redirect "/account"
        end
      end

      post '/teams/:slug/members' do |slug|
        only_for_team_managers(slug, "You are not allowed to add team members.") do |team|
          team.recruit(params[:usernames], current_user)
          team.save

          redirect "/teams/#{slug}"
        end
      end

      put '/teams/:slug/leave' do |slug|
        only_with_existing_team(slug) do |team|
          team.dismiss(current_user.username)

          redirect "/#{current_user.username}"
        end
      end

      delete '/teams/:slug/members/:username' do |slug, username|
        only_for_team_managers(slug, "You are not allowed to remove team members.") do |team|
          team.dismiss(username)

          redirect "/teams/#{slug}"
        end
      end

      put '/teams/:slug' do |slug|
        only_for_team_managers(slug, "You are not allowed to edit the team.") do |team|
          if team.defined_with(params[:team], current_user).save
            redirect "/teams/#{team.slug}"
          else
            flash[:error] = "Slug can't be blank"
            redirect "/teams/#{team.slug}"
          end
        end
      end

      put '/teams/:slug/confirm' do |slug|
        only_with_existing_team(slug) do |team|

          unless team.unconfirmed_members.include?(current_user)
            flash[:error] = "You don't have a pending invitation to this team."
            redirect "/"
          end

          team.confirm(current_user.username)

          redirect "/teams/#{slug}"
        end
      end

      post "/teams/:slug/managers" do |slug|
        only_for_team_managers(slug, "You are not allowed to add managers to the team.") do |team|
          user = ::User.find_by_username(params[:username])
          unless user.present?
            flash[:error] = "Unable to find user #{params[:username]}"
            redirect "/teams/#{slug}"
          end

          team.managed_by(user)

          redirect "/teams/#{slug}"
        end
      end

      delete "/teams/:slug/managers" do |slug|
        only_for_team_managers(slug, "You are not allowed to add managers to the team.") do |team|
          user = ::User.find_by_username(params[:username])
          team.managers.delete(user) if user

          redirect "/teams/#{slug}"
        end
      end

      post "/teams/:slug/disown" do |slug|
        # please_login("/teams/#{slug}") ? What with this?

        only_with_existing_team(slug) do |team|
          if team.managers.size == 1
            flash[:error] = "You can't quit when you're the only manager."
            redirect "/teams/#{slug}"
          else
            team.managers.delete(current_user)
            redirect "/account"
          end
        end
      end

      private

      def only_for_team_managers(slug, message)
        only_with_existing_team(slug) do |team|
          if team.managed_by?(current_user)
            yield team
          else
            flash[:error] = message
            redirect "/teams/#{slug}"
          end
        end
      end

      def only_with_existing_team(slug)
        team = Team.find_by_slug(slug)

        if team
          yield team
        else
          flash[:error] = "We don't know anything about team '#{slug}'"
          redirect '/'
        end
      end
    end
  end
end
