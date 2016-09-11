module ExercismWeb
  module Routes
    class Requests < Core
      post '/teams/:slug/requests' do |slug|
        please_login
        only_with_existing_team(slug) do |team|
          request = request_for_user_and_team(current_user, team)

          if request.present?
            flash[:error] = "You have already requested to join this team."
            redirect "/"
          end

          TeamMembershipRequest.create(user: current_user, team: team)

          flash[:success] = "Request sent to team #{slug}"
          redirect "/teams"
        end
      end

      post '/teams/:slug/request/:username/accept' do |slug, username|
        please_login
        only_for_team_managers(slug, "You are not allowed to manage team members.") do |team|
          user = ::User.find_by_username(username)
          request = request_for_user_and_team(user, team)

          unless request.present? && request.pending?
            flash[:error] = "This user have not requested to join this team."
            redirect "/"
          end

          request.accept!
          flash[:success] = "#{username} are now a member of team #{slug}."
          redirect "/teams/#{slug}/manage"
        end
      end

      post '/teams/:slug/request/:username/refuse' do |slug, username|
        please_login
        only_for_team_managers(slug, "You are not allowed to manage team members.") do |team|
          user = ::User.find_by_username(username)
          request = request_for_user_and_team(user, team)

          unless request.present? && request.pending?
            flash[:error] = "This user have not requested to join this team."
            redirect "/"
          end

          request.refuse!
          flash[:success] = "Request from user #{username} was refused."
          redirect "/teams/#{slug}/manage"
        end
      end

      private

      def request_for_user_and_team(user, team)
        TeamMembershipRequest.find_by(user: user, team: team)
      end
    end
  end
end
