module ExercismWeb
  module Routes
    class Invitations < Core
      post '/teams/:slug/invitations' do |slug|
        please_login
        only_for_team_managers(slug, "You are not allowed to add team members.") do |team|
          team.invite_with_usernames(params[:usernames], current_user)
          team.save

          flash[:success] = "Invitation sent to team #{slug}"
          redirect "/teams/#{slug}/manage"
        end
      end

      post '/teams/:slug/invitation/accept' do |slug|
        please_login
        only_with_existing_team(slug) do |team|
          invite = invite_for_user_and_team(current_user, team)

          unless invite.present?
            flash[:error] = "You don't have a pending invitation to this team."
            redirect "/"
          end

          invite.accept!
          flash[:success] = "You are now a member of team #{slug}."
          redirect "/teams/#{slug}"
        end
      end

      post '/teams/:slug/invitation/refuse' do |slug|
        please_login
        only_with_existing_team(slug) do |team|
          invite = invite_for_user_and_team(current_user, team)

          unless invite.present?
            flash[:error] = "You don't have a pending invitation to this team."
            redirect "/"
          end

          invite.refuse!
          flash[:success] = "Invite from team #{slug} was refused."
          redirect "/"
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

      def invite_for_user_and_team(user, team)
        TeamMembershipInvite.pending.find_by(user: user, team: team)
      end
    end
  end
end
