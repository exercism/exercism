module App
  module User
    class Account
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def username
        user.username
      end

      def github_url
        "https://github.com/#{username}"
      end

      def api_key
        # user.api_key
        'fak3a41k37'
      end

      def email
        user.email
      end

      def teams
        @teams ||= user.teams | user.teams_created
      end

      def completed_in_tracks
        user.exercises.completed.group_by(&:language).map do |language, exercises|
          App::User::Track.new(language, exercises.map {|e| App::User::Exercise.new(e)})
        end
      end
    end
  end
end
