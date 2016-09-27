module ExercismWeb
  module Helpers
    module TeamAccess
      def only_with_existing_team(slug)
        team = Team.find_by_slug(slug)

        if team
          yield team
        else
          flash[:error] = "We don't know anything about team '#{slug}'"
          redirect '/'
        end
      end

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
    end
  end
end
