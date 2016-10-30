module ExercismWeb
  module Routes
    class Invitations < Core
      post '/teams/:slug/invitations' do |slug|
        please_login
        team = Team.find_by(slug: params[:slug])
        valid_invitee = (params[:usernames].split(",") - team.members.map(&:username)).join(",")
        only_for_team_managers(slug, "You are not allowed to add team members.") do |team|
          team.invite_with_usernames(valid_invitee, current_user)
          team.save

          flash[:success] = "Invitation sent to team #{slug}" if valid_invitee.size > 0
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

      def invite_for_user_and_team(user, team)
        TeamMembershipInvite.pending.find_by(user: user, team: team)
      end
    end
  end
end
