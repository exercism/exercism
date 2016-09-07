module ExercismWeb
  module Routes
    # rubocop:disable Metrics/ClassLength
    class Teams < Core
      get '/teams' do
        please_login

        page = params[:page] || 1

        if params["q"].present?
          tag = Tag.find_by(name: params["q"])
          teams = Team.search_public_with_tag(tag)
        else
          teams = Team.search_public
        end

        locals = {
          tag: params["q"],
          teams: teams.paginate(page: page, per_page: 10),
        }

        erb :"teams/list", locals: locals
      end

      # Form to create a new team.
      get '/teams/new' do
        please_login
        erb :"teams/new", locals: { team: Team.new }
      end

      # Create a new team.
      post '/teams/new' do
        please_login
        team = Team.by(current_user).defined_with(params[:team], current_user)
        if team.valid?
          team.save
          TeamMembership.create(team: team, user: current_user, inviter: current_user, confirmed: true)
          redirect "/teams/#{team.slug}/directory"
        else
          erb :"teams/new", locals: { team: team }
        end
      end

      get '/teams/:slug/?' do |slug|
        redirect '/teams/%s/streams' % slug
      end

      get '/teams/:slug/streams' do |slug|
        please_login
        only_with_existing_team(slug) do |team|
          unless team.includes?(current_user)
            flash[:error] = "You may only view team pages for teams that you are a member of, or that you manage."
            redirect '/'
          end

          locals = {
            team: team,
            stream: TeamStream.new(team, current_user.id, params['page'] || 1, params['per_page']),
            active: 'stream',
          }
          erb :"teams/stream", locals: locals
        end
      end

      get '/teams/:slug/streams/tracks/:id' do |slug, track_id|
        please_login
        only_with_existing_team(slug) do |team|
          unless team.includes?(current_user)
            flash[:error] = "You may only view team pages for teams that you are a member of, or that you manage."
            redirect '/'
          end

          stream = TeamStream.new(team, current_user.id)
          stream.track_id = track_id.downcase

          locals = {
            team: team,
            stream: stream,
            active: 'stream',
          }

          erb :"teams/stream", locals: locals
        end
      end

      get '/teams/:slug/streams/tracks/:id/exercises/:problem' do |slug, track_id, problem_slug|
        please_login
        only_with_existing_team(slug) do |team|
          unless team.includes?(current_user)
            flash[:error] = "You may only view team pages for teams that you are a member of, or that you manage."
            redirect '/'
          end

          stream = TeamStream.new(team, current_user.id)
          stream.track_id = track_id.downcase
          stream.slug = problem_slug.downcase

          locals = {
            team: team,
            stream: stream,
            active: 'stream',
          }

          erb :"teams/stream", locals: locals
        end
      end

      get '/teams/:slug/streams/users/:username' do |slug, username|
        please_login
        only_with_existing_team(slug) do |team|
          unless team.includes?(current_user)
            flash[:error] = "You may only view team pages for teams that you are a member of, or that you manage."
            redirect '/'
          end

          user = ::User.find_by_username(username)
          stream = TeamStream.new(team, current_user.id)

          unless user.present? && stream.user_ids.include?(user.id)
            flash[:error] = "You may only view activity for existing team members."
            redirect '/'
          end

          stream.user = user

          locals = {
            team: team,
            stream: stream,
            active: 'stream',
          }

          erb :"teams/stream", locals: locals
        end
      end

      get '/teams/:slug/directory' do |slug|
        please_login
        only_with_existing_team(slug) do |team|
          unless team.includes?(current_user)
            flash[:error] = "You may only view team pages for teams that you are a member of, or that you manage."
            redirect '/'
          end

          locals = {
            team: team,
            members: team.all_members.sort_by { |m| m.username.downcase },
            active: 'directory',
          }

          erb :"teams/directory", locals: locals
        end
      end

      # Remove yourself from a team.
      put '/teams/:slug/leave' do |slug|
        please_login
        only_with_existing_team(slug) do |team|
          team.dismiss(current_user.username)

          redirect "/#{current_user.username}"
        end
      end

      ## Team Management ##

      # Team management dashboard
      get '/teams/:slug/manage' do |slug|
        please_login
        only_for_team_managers(slug, "You are not allowed to manage this team.") do |team|
          locals = {
            team: team,
            members: team.all_members.sort_by { |m| m.username.downcase },
            active: 'manage',
          }
          erb :"teams/manage", locals: locals
        end
      end

      # Delete a team.
      delete '/teams/:slug' do |slug|
        please_login
        only_for_team_managers(slug, "You are not allowed to delete the team.") do |team|
          team.destroy_with_memberships!

          flash[:success] = "Team #{slug} has been destroyed"
          redirect "/account"
        end
      end

      # Delete a team member.
      delete '/teams/:slug/members/:username' do |slug, username|
        please_login
        only_for_team_managers(slug, "You are not allowed to remove team members.") do |team|
          team.dismiss(username)

          flash[:success] = "#{username} removed from team #{slug}"
          redirect "/teams/#{slug}/manage"
        end
      end

      # Update team information.
      put '/teams/:slug' do |slug|
        please_login
        only_for_team_managers(slug, "You are not allowed to edit the team.") do |team|
          if team.defined_with(params[:team], current_user).save
            redirect "/teams/#{team.slug}"
          else
            flash[:error] = "Slug can't be blank"
            redirect "/teams/#{team.slug}"
          end
        end
      end

      # Add managers to a team.
      post "/teams/:slug/managers" do |slug|
        please_login
        only_for_team_managers(slug, "You are not allowed to add managers to the team.") do |team|
          user = ::User.find_by_username(params[:username])
          unless user.present?
            flash[:error] = "Unable to find user #{params[:username]}"
            redirect "/teams/#{slug}/manage"
          end

          team.managed_by(user)

          redirect "/teams/#{slug}/manage"
        end
      end

      # Remove a manager from a team.
      delete "/teams/:slug/managers" do |slug|
        please_login
        only_for_team_managers(slug, "You are not allowed to remove managers from the team.") do |team|
          user = ::User.find_by_username(params[:username])
          team.managers.delete(user) if user

          redirect "/teams/#{slug}/manage"
        end
      end

      # Quit managing a team.
      post "/teams/:slug/disown" do |slug|
        please_login
        only_with_existing_team(slug) do |team|
          if team.managers.size == 1
            flash[:error] = "You can't quit when you're the only manager."
            redirect "/teams/#{slug}/manage"
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
    # rubocop:enable Metrics/ClassLength
  end
end
