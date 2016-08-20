module ExercismWeb
  module Presenters
    class Profile
      DEFAULTS = { shared: false }.freeze

      def initialize(user, current_user=user, options={})
        @user = user
        @current_user = current_user
        @options = DEFAULTS.merge(options)
      end

      def username
        user.username
      end

      def own?
        user.id == current_user.id
      end

      def shared?
        @options[:shared]
      end

      def exercises
        @exercises ||= user.exercises.where(archived: false).where('iteration_count > 0')
      end

      def progress_hash
        UserProgression.user_progress(user).sort_by(&:last_updated)
      end

      def archived_exercises
        @archived_exercises ||= user.exercises.where(archived: true).where('iteration_count > 0')
      end

      def archived_grouped_exercises
        @archived_exercises.group_by(&:language)
      end

      def access?(exercise)
        shared? || current_user.access?(exercise)
      end

      def has_current_exercises?
        exercises.count > 0
      end

      def has_archived_exercises?
        archived_exercises.count > 0
      end

      def teams
        user.team_invites | user.teams | user.managed_teams
      end

      def has_teams?
        teams.any?
      end

      def has_share_key?
        user.share_key
      end

      def is_track_mentor?
        user.track_mentor.any?
      end

      def mentored_tracks
        user.track_mentor
      end

      def finished_tracks
        @finished_tracks ||= UserFinishedTracks.tracks(user)
      end

      attr_reader :user, :current_user
    end
  end
end
